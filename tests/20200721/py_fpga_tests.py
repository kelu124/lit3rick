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
import us_display

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

def test_i2c_acces_to_signal_ram():
    signal = gen_signal()
    fpga.wrtie_signal_through_i2c(signal)
    read_signal = fpga.read_signal_through_i2c()
    assert all(signal == read_signal), (f'readed signal not equal with written signal!')
    print(f'I2C access to signal ram test passed!')

def test_spi_access_to_signal_ram():
    signal = gen_signal()
    fpga.wrtie_signal_through_i2c(signal)
    read_signal = fpga.read_signal_through_spi()
    assert all(signal == read_signal), (f'readed signal not equal with written signal!')
    print(f'SPI access to signal ram test passed!')

def test_i2s_access_to_signal_ram():
    signal = gen_signal()
    fpga.wrtie_signal_through_i2c(signal)

    signal = signal >> 4
    signal = np.uint8(signal)
    read_signal = fpga.read_signal_through_i2s()
    assert all(signal == read_signal), (f'readed signal not equal with written signal!')
    print(f'I2S access to signal ram test passed!')

def test_fft():
    signal = gen_signal()
    
    fpga.wrtie_signal_through_i2c(signal)
    # tmp_signal = fpga.read_signal_through_i2c()

    # tmp = fpga.read_signal_through_i2c()
    print(hex(fpga.i2c_read(12)))
    # time.sleep(1)
    fpga.calc_fft()
    # fpga.calc_fft()
    time.sleep(1)

    # fpga_fft = fpga.read_fft_through_i2c()
    fpga_fft = fpga.read_fft_through_spi()
    # debug = fpga.read_signal_through_i2c()
    # fname = Path.cwd() / "debug.bin"
    # fname.write_bytes(bytes(debug))

    tmp = signal.reshape(256, -1)
    ref_fft = dft.dft_python_model(tmp)
    # ref_fft = alaw.alaw_compress(ref_fft)
    
    # err = 0
    # for i in range(256):
    #     if ref_fft[i] != debug[i]:
    #         err += 1
    
    # if err == 0:
    #     print("Output data from FFT core is correct")
    # else:
    #     print(f'Output data from FFT core is incorrect with {err} errors')

    # print((debug[:256] & 0xFFF))
    print(ref_fft[:])
    print(fpga_fft[:])
    print(hex(fpga.i2c_read(12)))
    print(f'FFT processing test passed!')

def gen_signal():
    signal = np.ndarray(8192, dtype=np.uint16)
    for i in range(len(signal)):
        # signal[i] = randint(0, 8192) & 0xFFF
        signal[i] = i & 0xFFF

    return signal

if __name__ == "__main__":
    i2c_bus = SMBus(1)
    spi = spidev.SpiDev()

    print("Initial speed setting %s Hz" % spi.max_speed_hz)

    spi.open(0,0) 
    # p = pyaudio.PyAudio()
    p = None
    fpga = py_fpga(i2c_bus=i2c_bus, py_audio=p, spi_bus=spi)

    # fpga.i2c_write(8, 8)
    
    #registers_test()
    # test_i2c_acces_to_signal_ram()
    # test_spi_access_to_signal_ram()
    # test_i2s_access_to_signal_ram()
    #test_fft()

    # fpga.capture_signal()
    # memContent = fpga.read_signal_through_spi()
    # print(list(map(hex, memContent)))
    # print(max(memContent))
    # print(min(memContent))

    dacVal =  400 
    hiloVal = 0 
    fpga.set_HILO(hiloVal)
    fpga.set_dac(dacVal,channel='A')
    fpga.capture_signal()
    time.sleep(1/2000.0)
    start = time.time()
    memContent = fpga.read_signal_through_spi()
    stop = time.time()
    print(start,stop)
    print(int((stop-start)*1000000),"us. Array:",memContent)
    print(int((stop-start)*1000000/8192),"us per point.")
    #memC = fpga.read_signal_through_i2c()
    #print(memC)
    us_display.sig_print(memContent,128,22,hiloVal,dacVal)
    np.savetxt("piezo_hilo"+str(hiloVal)+"_"+str(dacVal)+"DAC.csv", memContent, delimiter=";")
