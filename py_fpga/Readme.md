# Readme

### Setting up the board

By creating the 

`fpga = py_fpga(i2c_bus=i2c_bus, py_audio=p, spi_bus=spi)`

Choosing the timings of the board: initial delay, pHV is positive HV length, PnHV is the negative one, PDamp the time to dampen the signal (unit being 1/64 of a microsecond _//note to self, check if that's right, and not 1/32_). All of this is happenning during the acquisition window that is 128us long.

`fpga.set_waveform(pdelay=1, PHV_time=11, PnHV_time=1, PDamp_time=100)`

### Setting up the variable gain values

The VGA can be set up by tranches of 8us, so with 16 values out of the 128us acquisition window. Values from 0 to 511.

```python
startVal,nPtsDAC = 250, 16
for i in range(nPtsDAC):
	fpga.set_dac(int(startVal + (i*(455-startVal))/nPtsDAC), mem=i)
```

Now we setup the HILO value, and setting the gain outside of the acquisition window. 

```python

hiloVal = 1 # High or low.
dacVal = 250 # on a range from 0 to 512
fpga.set_HILO(hiloVal)
fpga.set_dac(dacVal)
```

### Running the acquisition

#### Starting to get the enveloppe for 10 acquisitions

Each is spaced by approx 1ms (time taken to do the FFT+filtering) + transfert through i2s (_//note to self, check again :)_.

`dataI2S = fpga.read_fft_through_i2s(10)`

#### Let's get the raw data for the last line in the previous acquisition?

`dataSPI = fpga.read_signal_through_spi()`

### Want to get computed value of the filter extraction through SPI ?

```python
fpga.calc_fft() 
time.sleep(3/1000.0) # normally takes ~800us to compute 8192pts
dataFFT = fpga.read_fft_through_spi()
```

## Images

### Content of the dataI2S

![](/images/i2s.png)

### Content of the dataSPI

![](/images/raw_ref.png)

### Content of the dataFFT

![](/images/fpga_fft.png)





Let me know if there's something else to add.
