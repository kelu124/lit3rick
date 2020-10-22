#!/usr/bin/python3

from pathlib import Path
from random import randint
from smbus2 import SMBus
from py_fpga import py_fpga
import time
import numpy as np
import spidev
import dft
import alaw
import us_display as viz
import matplotlib.pyplot as plt
from ctypes import *
from contextlib import contextmanager
import pyaudio

ERROR_HANDLER_FUNC = CFUNCTYPE(None, c_char_p, c_int, c_char_p, c_int, c_char_p)

def py_error_handler(filename, line, function, err, fmt):
    pass

c_error_handler = ERROR_HANDLER_FUNC(py_error_handler)

@contextmanager
def noalsaerr():
    asound = cdll.LoadLibrary('libasound.so')
    asound.snd_lib_error_set_handler(c_error_handler)
    yield
    asound.snd_lib_error_set_handler(None)


if __name__ == "__main__":
    i2c_bus = SMBus(1)
    spi = spidev.SpiDev()
    spi.open(0,0)
    p = None
    with noalsaerr():
        p = pyaudio.PyAudio()
    p = pyaudio.PyAudio()

    # Starting an object 
    fpga = py_fpga(i2c_bus=i2c_bus, py_audio=p, spi_bus=spi)
    # Setting up the pulse - PHV time for duration of positivepulse
    fpga.set_waveform(pdelay=1, PHV_time=11, PnHV_time=1, PDamp_time=100)

    print("Setting DAC")
    startVal,nPtsDAC = 450, 16
    for i in range(nPtsDAC):
        fpga.set_dac(int(startVal + (i*(455-startVal))/nPtsDAC), mem=i)

    fpga.set_dac(450, mem=0)
    fpga.set_dac(450, mem=1)
    fpga.set_dac(450, mem=2)

    hiloVal = 1
    dacVal = 100
    fpga.set_HILO(hiloVal)
    fpga.set_dac(dacVal) 
    # Capturing the signal
    fpga.capture_signal()
    data = fpga.read_fft_through_i2s(10)  
    print("Acq done, reading through spi")
    # Reading the signal
    data = fpga.read_signal_through_spi()
    fig = plt.figure(figsize=(15,5))
    fig = plt.plot(data[0:64*50] # 64msps * 50us
    plt.savefig("raw_ref.png")   

    print("Starting FFT calc")
    fpga.calc_fft()                        # onboard filtering calculation
    time.sleep(3/1000.0)                   # let's wait, usally takes 800ms
    fpga_fft = fpga.read_fft_through_spi() # reading filtered signal
    print("FFT obtained")
    fig = plt.figure(figsize=(15,5))
    fig = plt.plot(fpga_fft)
    plt.savefig("fpga_fft.png")   
