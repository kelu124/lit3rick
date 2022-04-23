#!/usr/bin/python3

import numpy as np

class py_fpga:
    __signal_size = 8192
    __spi_max_speed_hz = 1E6

    def __init__(self, spi_bus=None):
        self.__spi_bus = spi_bus
        if self.__spi_bus != None:
            self.__spi_bus.max_speed_hz = self.__spi_max_speed_hz
        
    def set_dac(self, val, shutdown=0):
        """ The function for setup DAC value for MCP4811
        Parameters val, and gain setup the DAC value, channel for write and gain respectivelly
        Parameter shutdown perform shutdown mode of the DAC
        For setup one of memory cells for the DAC value during acquisition set into mem parameter a cell address
        Cells into memory have a word addressing from 0 to 15. 
        These 16 values will applied during acquisition sequentially from 0 to 15 after the constant period (512 samples)
        """
        
        tmp = 0
        tmp = (val & (2**10-1)) << 2 # do a shift, because we have 10 bit ADC, but 12 bit ADC compatible register

        if shutdown == 0:
            tmp |= (1 << 12)


    def set_HILO(self, val):
        return 1

    def read_signal_through_spi(self):
        signal = bytes(0)
        
        for j in range(self.__signal_size//1024):
            addr = []
            for i in range(j * 1024, j * 1024 + 1025, 1):
                addr += [(i >> 8) & 0xFF, i & 0xFF]

            result = self.__spi_bus.xfer2(addr)
            signal += bytes(result[2:])

        signal = np.frombuffer(signal, dtype=np.int16)
        return signal
    

if __name__ == __main__:



0x80BC - configures 0xBC at [7:0] of temporary dac register.
0xC031 - configures 0x31 at [15:8] of temporary dac register and also configures the dac with 0x31BC
0x4000 - triggers Acquisition
** Wait for 128us time to complete the acquisition.

0x0000 sends 0x0 address to read data during next two spi transfers

then
0001
