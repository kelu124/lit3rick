#!/usr/bin/python3
from smbus2 import i2c_msg
import numpy as np
import pyaudio
import threading
import math

class py_fpga_jn3:
    __fft_size = 256
    __spi_max_speed_hz = 1000000
    __CHUNK = 2**10
    __FORMAT = pyaudio.paInt16
    __CHANNELS = 2
    __RATE = 48000
    __RECORD_SECONDS = 0.10

    def __init__(self, i2c_bus, spi_bus=None, py_audio=None, i2c_dev_addr=0x25):
        self.__i2c_dev_addr = i2c_dev_addr
        self.__i2c_bus = i2c_bus
        self.__spi_bus = spi_bus
        self.__py_audio = py_audio
        self.__i2s_header = np.array([i for i in range(32)], dtype=np.uint8)

        if self.__spi_bus != None:
            self.__spi_bus.max_speed_hz = self.__spi_max_speed_hz
        
    def set_pulser(self, nHalfCycles=1, PHV_PnHV_width=3, PHV_PnHV_delay=1):
        temp = 0xFFFF;       
        temp &= (8 << 12)
        temp |= (nHalfCycles << 8)
        temp |= (PHV_PnHV_width << 4)
        temp |=  PHV_PnHV_delay
        self.__spi_bus.writebytes({(temp >> 8) & 0xFF})
        self.__spi_bus.writebytes({temp & 0xFF})
   
    def set_receiver(self, hilo=1, vga_mode=0, dac_val=100):
        temp = 0xA000;
        temp |= (hilo << 11)
        temp |= (vga_mode << 9)
        temp |=  dac_val
        self.__spi_bus.writebytes({(temp >> 8) & 0xFF})
        self.__spi_bus.writebytes({temp & 0xFF})
        
    def set_delay(self, pdelay=0):
        temp = 0x6000;
        temp |= (pdelay)
        self.__spi_bus.writebytes({(temp >> 8) & 0xFF})
        self.__spi_bus.writebytes({temp & 0xFF})
        
    def set_prf(self, prf=9):
        temp = 0x2000;
        temp |= (prf)
        self.__spi_bus.writebytes({(temp >> 8) & 0xFF})
        self.__spi_bus.writebytes({temp & 0xFF})
  
    def read_signal_through_spi(self, signal_size=8192):
        signal = bytes(0)
        
        for j in range(signal_size//1024):
            addr = []
            for i in range(j * 1024, j * 1024 + 1024, 1):
                addr += [0x00, 0x00]

            result = self.__spi_bus.xfer2(addr)
            signal += bytes(result)
        
        addr = [0x00, 0x00]
        result = self.__spi_bus.xfer2(addr)
        signal += bytes(result)
        signal = np.frombuffer(signal[2:], dtype=np.uint16)
        return signal

    def capture_signal(self, signal_avg=1):
        self.__spi_bus.xfer2({0x40})
        self.__spi_bus.xfer2({signal_avg})

    def __align_data(self, frames):
        data = np.copy(np.array(frames, dtype=np.uint8))
        data[0:-1:2] = data[0:-1:2] ^ data[1::2]
        data[1::2] = data[0:-1:2] ^ data[1::2]
        data[0:-1:2] = data[0:-1:2] ^ data[1::2]
        tmp = data

        idx = np.where(tmp == 0x00)
        if len(idx[0]) != 0:
            idx = idx[0][0]
        else:
            idx = 0
        # print(list(map(hex, tmp[idx:idx+512:1])))
        while not (tmp[idx:idx+32:1] == self.__i2s_header).all():
            tmp = ((data[:-1] & 0x7F) << 1) | ((data[1:] >> 7) & 0x01)
            # print(f'Original data = 0x{data[2]:02x} 0x{data[1]:02x}')
            # print(f'Shifted data = 0x{tmp[1]:02x} 0x{tmp[0]:02x}')
            idxs = np.where(tmp == 0x00)[0]
            idx = -1
            for i in idxs:
                if i + 32 < len(tmp):
                    if (tmp[i:i+32:1] == self.__i2s_header).all():
                        idx = i
                        break

            if idx == -1:
                idx = 0
                
            data = tmp

        data = tmp[idx:]
        return data

    def __capture(self, ms):
        stream = self.__py_audio.open(format=self.__FORMAT,
                        channels=self.__CHANNELS,
                        rate=self.__RATE,
                        input=True,
                        frames_per_buffer=self.__CHUNK, 
                        input_device_index=1)

        print("* recording")

        frames = []

        for i in range(0, int(math.ceil(self.__RATE * self.__CHANNELS / self.__CHUNK * ms / 1000))):
            data = stream.read(self.__CHUNK)
            # print(data)
            frames.append(list(data))

        #print("* done recording")

        stream.stop_stream()
        stream.close()
        self.__py_audio.terminate()
        return frames
