# Contents of the folder

* lit3_v2.0.bin : binary for the up5k
* prog_ram.sh : programming the fpga without going to the flash (takes longer)

# Use

Make sure you have copied the `lit3prog` utility and copied it to your bins. The source and makefiles are in the `utilities` folder. Then, just type

```
./prog_ram.sh
```

Then should appear a device on your i2c line (`check possible with i2cdetect -y 1`) at 0x25
```
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- 25 -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- 48 -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --
```

#  Play !
