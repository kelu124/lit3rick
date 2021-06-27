![GitHub repo size](https://img.shields.io/github/repo-size/kelu124/lit3rick?style=plastic)
![GitHub language count](https://img.shields.io/github/languages/count/kelu124/lit3rick?style=plastic)
![GitHub top language](https://img.shields.io/github/languages/top/kelu124/lit3rick?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/kelu124/lit3rick?color=red&style=plastic)

[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/kelu124) 
[![Kofi](https://badgen.net/badge/icon/kofi?icon=kofi&label)](https://ko-fi.com/G2G81MT0G)

[![Slack](https://badgen.net/badge/icon/slack?icon=slack&label)](https://join.slack.com/t/usdevkit/shared_invite/zt-2g501obl-z53YHyGOOMZjeCXuXzjZow)
[![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org)


[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/G2G81MT0G)

# the up5k lit3rick open hardware ultrasound pulse echo board

## Presentation of the hardware

![](/images/top.jpg)

* Lattice: up5k. Onboard RAM for 64k points saves.
* Onboard flash : W25X10CLSNIG
* Pulser : HV7361GA-G: adaptable to +-100V pulses. Onboard is 5V pulse.
* AD8331 for gain
* ADC: AD9629BCPZ-65: 12bits, reaching 64Msps here
* DAC: MCP4812-E/MS for 8us gain segments

# Content

* [Hardware files](/hardware/). Stemming from the forkable [upverter design](https://upverter.com/design/kelu124/lit3rick/).
* [Utilities to program the up5k](/program/): no FTDI, all through the RPi header, using its SPI bus to program either the board flash, or the fpga directy.
* [The python tools](/py_fpga/): to facilitate the acquisitions.
* [The cursed gateware](/verilog): for the current gateware linked to the python library.

## Some images, unipolar pulse at Vpulse = 5V

### Python setup

An example from the [py_fpga](/py_fpga/) folder, summarized. Check the visualisation of the acquisitions below.

```python

# Setting the fpga buses
fpga = py_fpga(i2c_bus=i2c_bus, py_audio=p, spi_bus=spi)

# Setting the 
fpga.set_waveform(pdelay=1, PHV_time=11, PnHV_time=1, PDamp_time=100)

# Setting the gain values
hiloVal = 1 # High or low.
dacVal = 250 # on a range from 0 to 512
fpga.set_HILO(hiloVal)
fpga.set_dac(dacVal)

# Setting the VGA
startVal,nPtsDAC = 250, 16
for i in range(nPtsDAC):
	fpga.set_dac(int(startVal + (i*(455-startVal))/nPtsDAC), mem=i)

# Reading 10 successive acquisitions
dataI2S = fpga.read_fft_through_i2s(10)

# Getting the detailed buffer (8192pts at 64msps)
dataSPI = fpga.read_signal_through_spi()

# "Manually" calculating the FFT and reading it
fpga.calc_fft() 
time.sleep(3/1000.0) # normally takes ~800us to compute 8192pts
dataFFT = fpga.read_fft_through_spi()

```

### Content of the dataI2S

![](/images/i2s.png)

### Content of the dataSPI

![](/images/raw_ref.png)

### Content of the dataFFT

![](/images/fpga_fft.png)

### Efficiency of enveloppe extraction and compression

![](/sample_acqs/lit3rick_i2s/lit3_i2s.jpg)

![](/sample_acqs/lit3rick_i2s/lit3_i2s_detailed.jpg)

# Benchmarking

## Benchmarking against the un0rick board 

![](/sample_acqs/compare_maxgain_b_90V.jpg)

## Checking the level of noise in each board, at max gain (no transducer plugged).

![](/sample_acqs/compare_noise.jpg)

# License

This work is based on two previous TAPR projects, [the echOmods project](https://github.com/kelu124/echomods/), and the [un0rick project](https://github.com/kelu124/un0rick) - its boards are open hardware and software, developped with open-source elements as much as possible.

Copyright Kelu124 (kelu124@gmail.com) 2020.

* The hardware is licensed under TAPR Open Hardware License (www.tapr.org/OHL)
* The software components are free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
* The documentation is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).

## Disclaimer

This project is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE. 

