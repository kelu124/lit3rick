## Notes

* Several issues with icestudio with PLL, RGB Driver, and SRAM IPs -> used iCEcube2 for PLL IP Generation
* Followed the User guide for RGB Driver instantiation
* SRAM IP as previuously

* Data : 
  * {TOP_T2,TOP_T1,HV_EN,HILO,ADC_DATA,2'd0}
  * ADC_DATA is 10 bits from D11 to D2
* Write to RAM: bit-order above 

* Modes of User SPI: (8-bit SPI): 2 successive 8-bit SPI words will form 16-bit data internally 
in the received 16 bits, [15:14]- bits are used as mode selection:(spi_mode)
  * 00 - reads the data from SRAM address at [12:0]-bits
  * 01 - Triggers the ADC
  * 10 - Stores the [7:0]-bits in DAC_VALUE[7:0]-bits
  * 11 - Stores the [7:0]-bits in DAC_VALUE[15:8]-bits and triggers DAC_SPI setting

# Indicator
* Red   - During ADC Data Capturing.
* Blue  - During SPI Transactions.
* Green - Ready or IDLE.
