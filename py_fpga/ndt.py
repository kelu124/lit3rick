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
from datetime import datetime

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

    now = datetime.now()

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
    fpga.set_waveform(pdelay=1, PHV_time=15, PnHV_time=7, PDamp_time=7)

    print("Setting DAC")
    startVal,nPtsDAC = 450, 16
    for i in range(nPtsDAC):
        fpga.set_dac(int(startVal + (i*(455-startVal))/nPtsDAC), mem=i)

    fpga.set_dac(100, mem=0)
    fpga.set_dac(450, mem=1)
    fpga.set_dac(450, mem=2)

    hiloVal = 1
    dacVal = 100
    fpga.set_HILO(hiloVal)
    fpga.set_dac(dacVal) 
    # Capturing the signal
    fpga.capture_signal() 
    print("Acq done, reading through spi")
    # Reading the signal
    data = fpga.read_signal_through_spi()
    data = [x/2048.0 for x in data]
    t = [x/64.0 for x in range(len(data))]
    fig = plt.figure(figsize=(15,5))
    fig = plt.plot( t[0:64*50],data[0:64*50] ) # 64msps * 50us
    plt.title("Gain set at "+str(dacVal)+ " - "+now.strftime("%m/%d/%Y, %H:%M:%S"))
    plt.xlabel('time (us)')
    plt.ylabel('V')
    plt.savefig("ndt_raw_detail.png")   

    fig = plt.figure(figsize=(15,5))
    fig = plt.plot( t,data ) # 64msps * 50us
    plt.title("Gain set at "+str(dacVal)+ " - "+now.strftime("%m/%d/%Y, %H:%M:%S"))
    plt.xlabel('time (us)')
    plt.ylabel('V')
    plt.savefig("ndt_raw_all.png")   

    fig = plt.figure(figsize=(15,5))
    L = len(data)
    LL = int(len(data)/2-1)
    f = [x*64.0/L for x in range(L)]
    FFT = np.abs(np.fft.fft(data))
    plt.plot(f[50:LL],FFT[50:LL])
    plt.title("FFT "+str(dacVal)+ " - "+now.strftime("%m/%d/%Y, %H:%M:%S"))
    plt.xlabel('Frequency (MHz)')
    plt.ylabel('Importance')
    plt.savefig("ndt_fft.png")   

    print("Starting FFT calc")
    fpga.calc_fft()                        # onboard filtering calculation
    time.sleep(3/1000.0)                   # let's wait, usally takes 800ms
    fpga_fft = fpga.read_fft_through_spi() # reading filtered signal
    fig = plt.figure(figsize=(15,5))
    tt = [x/2.0 for x in range(len(fpga_fft))]
    fig = plt.plot(tt,fpga_fft)
    plt.xlabel('time (us)')
    plt.ylabel('Compressed enveloppe')
    plt.savefig("ndt_filtered.png")   
