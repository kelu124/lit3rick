![GitHub repo size](https://img.shields.io/github/repo-size/kelu124/lit3rick?style=plastic)
![GitHub language count](https://img.shields.io/github/languages/count/kelu124/lit3rick?style=plastic)
![GitHub top language](https://img.shields.io/github/languages/top/kelu124/lit3rick?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/kelu124/lit3rick?color=red&style=plastic)

[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/kelu124) 
[![Kofi](https://badgen.net/badge/icon/kofi?icon=kofi&label)](https://ko-fi.com/G2G81MT0G)

[![Slack](https://badgen.net/badge/icon/slack?icon=slack&label)](https://join.slack.com/t/usdevkit/shared_invite/zt-2g501obl-z53YHyGOOMZjeCXuXzjZow)
[![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org)


[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/G2G81MT0G)

# the up5k lit3rick open hardware ultrasound pulse echo board, 100dB gain

# OSHWA certified ! 

[https://certification.oshwa.org/fr000016.html](https://certification.oshwa.org/fr000016.html)

## Presentation of the hardware

* Lattice: up5k. Onboard RAM for 64k points saves.
* Onboard flash : W25X10CLSNIG
* Pulser : HV7361GA-G: adaptable to +-100V pulses. Onboard is 5V pulse.
* AD8332 for gain
* ADC: 10bits, reaching 64Msps here
* DAC: MCP4812-E/MS for 8us gain segments

* [Schematics](/altium/OUTPUT/Schematics/ice40_schematic.PDF)

[![](build/schematics.png)](/altium/OUTPUT/Schematics/ice40_schematic.PDF)

# Pics

## Design 

![](/bot.png)

![](/top.png)

## Prod

![](build/imagelit3_32.png)

## Python user code

* Principles are [here](/lit3-32/icestudio/Readme.md)
* Python code is [here](/icestudio/python/python.py)

## Verilog: using icestudio (work in progress)

![](/icestudio/icestudio_screenshot.png)

# Outputs

Below are echoes from a 5V pulse, gain at 350/1000, HILO being low.

![](icestudio/G350_HL0_5V.jpg)

# License

This work is based on two previous TAPR projects, [the echOmods project](https://github.com/kelu124/echomods/), and the [un0rick project](https://github.com/kelu124/un0rick) - its boards are open hardware and software, developped with open-source elements as much as possible.

Copyright Kelu124 (kelu124@gmail.com) 2021.

* The hardware is licensed under TAPR Open Hardware License (www.tapr.org/OHL)
* The software components are free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
* The documentation is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).

## Disclaimer

This project is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE. 

