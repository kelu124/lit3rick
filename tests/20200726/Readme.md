# 20200726 

## Adding a 0.1uF on LMD seems to improve gain:

Still noise because.. wire = antenna.

![](/tests/20200726/images/hilo0_gain0450.png)

![](/tests/20200725/imgs/piezo_hilo0_403DAC.csv_signal.jpg)

## Possible to check the gain.

Beware though, seems to saturate after 500 (normal as DAC output has a 0-2V range).

## Notes on SNR

#### Best case SNR

Source:  : https://www.cypress.com/file/200121/download

SNR dB = 6.02 x ENOB  + 1.76

Improving SNR by
- 4bits = 256 samples
- 2bits = 4^2 = 16

#### Costing

* 10: 1,927$ -> 190$
* 15: 2,403$ -> 160$ -> 350$
* 20: 3,000$ -> 150$
