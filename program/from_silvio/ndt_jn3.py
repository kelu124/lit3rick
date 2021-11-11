#!/usr/bin/python3

from pathlib import Path
from random import randint
from smbus2 import SMBus
from py_fpga_jn3 import py_fpga_jn3
import time
import numpy as np
import spidev
import us_display as viz
import matplotlib.pyplot as plt
from ctypes import *
from datetime import datetime

ERROR_HANDLER_FUNC = CFUNCTYPE(None, c_char_p, c_int, c_char_p, c_int, c_char_p)

def py_error_handler(filename, line, function, err, fmt):
    pass

c_error_handler = ERROR_HANDLER_FUNC(py_error_handler)


if __name__ == "__main__":

    now = datetime.now()

    i2c_bus = SMBus(1)
    spi = spidev.SpiDev()
    spi.open(0,0)
    p = None

    # Starting an object
    fpga = py_fpga_jn3(i2c_bus=i2c_bus, py_audio=p, spi_bus=spi)
    # Setting up the pulse - PHV time for duration of positivepulse
    fpga.set_pulser(nHalfCycles=2, PHV_PnHV_width=4, PHV_PnHV_delay=1)

    print("Setting receiver")
    #setting reciver parameters
    hilo = 1
    vga_mode = 0       # 0-constant; 1-linear; 2-VGA by segment
    dac_val = 100      # max 500
    fpga.set_receiver(hilo,vga_mode,dac_val)
    
    #setting pfr 1=1024 cycles
    prf = 127 # max 4095, 127 = prf 500 Hz when ADC is 65 MHz
    fpga.set_prf(prf)

    #setting pdelay max=4095 cycles or max=4095x64 cycles = 4095 us when ADC is 64 MHz
    pdelay_base = 1 # 0=1 cycle, 1=64 cycles=1us when ADC is 64 MHz
    pdelay_set = 0 # max 4095, when pdelay_base=1, (pdelay_set*64 + 360 + signal_size) should be smaller than (prf * 1024)
    pdelay = pdelay_set + (pdelay_base*4096)
    fpga.set_delay(pdelay)

    # Capturing the signal
    signal_avg = 63 # max 63
    fpga.capture_signal(signal_avg)
    time.sleep(prf*1024*signal_avg/65000000+1)
    print("Acq done, reading through spi")
    
    # Reading the signal
    data = fpga.read_signal_through_spi(signal_size=8192)
    
    data = data[:-1] #Jason remove the last element
    #data = data[1:] #Jason remove the first element for test purpose
    
    # Save data to file
    f = open("data.txt", "w") 
    f.writelines(["%s\n" % item  for item in data])
    f.close()
    
    # data = [x/2048.0 for x in data]
    data = [x for x in data]
    t = [x/64.0 for x in range(len(data))]
    fig = plt.figure(figsize=(15,5))
    # fig = plt.plot( t[0:64*50],data[0:64*50] ) # 64msps * 50us
    fig = plt.plot( t[0:64*125],data[0:64*125] ) # 64msps * 125us
    plt.title("Gain set at "+str(dac_val)+ " - "+now.strftime("%m/%d/%Y, %H:%M:%S"))
    plt.xlabel('time (us)')
    plt.ylabel('V')
    #plt.savefig("ndt_raw_detail.png")
    
    #fig = plt.figure(figsize=(15,5))
    #fig = plt.plot( t,data ) # 64msps * 50us
    #plt.title("Gain set at "+str(dac_val)+ " - "+now.strftime("%m/%d/%Y, %H:%M:%S"))
    #plt.xlabel('time (us)')
    #plt.ylabel('V')
    #plt.savefig("ndt_raw_all.png")
    
    plt.show()
