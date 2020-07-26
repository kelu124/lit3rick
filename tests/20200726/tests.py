#!/usr/bin/python3

from pathlib import Path
from random import randint
from smbus2 import SMBus
import pyaudio
from py_fpga import py_fpga
import time
import numpy as np
import spidev
import dft
import alaw

def registers_test():
    test_data = []
    for i in range(4):
        test_data.append(randint(0, 2**32))
        fpga.i2c_write(i << 2, test_data[i])

    for i in range(4):
        tmp = fpga.i2c_read(i << 2)
        assert test_data[i] == tmp, (f'Readed incorrect value from register {i}')

    for i in range(4):
        fpga.i2c_write(i << 2, 0)

    print(f'Registers test passed!')

def test_i2c_acces_to_signal_ram(signal):
    #signal = gen_signal()
    #fpga.wrtie_signal_through_i2c(signal)
    print("\n- Testing i2c access to signal.. ")
    read_signal = fpga.read_signal_through_i2c()
    assert all(signal == read_signal), (f'readed signal not equal with written signal!')
    print(read_signal)
    print(f'I2C access to signal ram test passed!')

def test_spi_access_to_signal_ram(signal):
    #signal = gen_signal()
    #fpga.wrtie_signal_through_i2c(signal)
    print("\n- Testing SPI access to signal.. ")
    read_signal = fpga.read_signal_through_spi()
    assert all(signal == read_signal), (f'readed signal not equal with written signal!')
    print(read_signal)
    print(f'SPI access to signal ram test passed!')

def test_i2s_access_to_signal_ram(signal):
    #signal = gen_signal()
    #fpga.wrtie_signal_through_i2c(signal)

    signal = signal >> 4
    signal = np.uint8(signal)
    print("\n- Testing i2s access to signal (on 8bits though).. ")
    read_signal = fpga.read_signal_through_i2s()
    assert all(signal == read_signal), (f'readed signal not equal with written signal!')
    print(read_signal)
    print(f'i2s access to signal space test passed!')

def fill_signal():
    signal = gen_signal()
    fpga.wrtie_signal_through_i2c(signal)
    return signal

def test_fft():

    print("\n- Testing onboard Enveloppe extraction..")
    fpga.calc_fft()
    print(f"Enveloppe calculated")
    fpga_fft = fpga.read_fft_through_spi()
    print(f"Enveloppe read from SPI.")
    print(f"Local calculation of enveloppe.")
    tmp = signal.reshape(256, -1)
    ref_fft = dft.dft_python_model(tmp)
    ref_fft = alaw.alaw_compress(ref_fft)
    
    assert all(ref_fft[1:] == fpga_fft[1:]), (f'readed signal not equal with written signal!')
    print(fpga_fft[1:])
    print(f'Onboard Enveloppe extraction processing test passed!')

def gen_signal():
    signal = np.ndarray(8192, dtype=np.uint16)
    for i in range(len(signal)):
        signal[i] = randint(0, 1023) & 0xFFF
        # signal[i] = i & 0xFFF

    return signal

if __name__ == "__main__":
    i2c_bus = SMBus(1)
    spi = spidev.SpiDev()
    spi.open(0,0)
    p = None
    p = pyaudio.PyAudio()
    fpga = py_fpga(i2c_bus=i2c_bus, py_audio=p, spi_bus=spi)

    
    # print(list(map(hex, memContent)))
    # print(max(memContent))
    # print(min(memContent))
    hiloVal = 1
    for dacVal in [0,200,250,300,350,400,450,500,550,600]: 
        fpga.set_dac(dacVal)
        fpga.set_HILO(hiloVal)
        fpga.capture_signal()
        time.sleep(1/2000.0)
        memContent = fpga.read_signal_through_spi()
        np.savetxt("k_RAW_hilo"+str(hiloVal)+"_"+str(dacVal)+"DAC.csv", memContent, delimiter=";")
        fpga.calc_fft()
        print(f"Enveloppe calculated")
        fpga_fft = fpga.read_fft_through_spi()
        np.savetxt("k_FFT_hilo"+str(hiloVal)+"_"+str(dacVal)+"DAC.csv", fpga_fft, delimiter=";")
 
    # fpga.capture_signal()

    # memContent = fpga.read_signal_through_spi()
    # print(memContent)
    # #memC = fpga.read_signal_through_i2c()
    # print(memC)
