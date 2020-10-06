# Readme

### Setting up the board

By creating the 

`fpga = py_fpga(i2c_bus=i2c_bus, py_audio=p, spi_bus=spi)`

Choosing the timings of the board: initial delay, pHV is positive HV length, PnHV is the negative one, PDamp the time to dampen the signal. All of this is happenning during the acquisition window that is 128us long.

`fpga.set_waveform(pdelay=1, PHV_time=11, PnHV_time=1, PDamp_time=100)`

### Setting up the DAC and gain values

```python
startVal,nPtsDAC = 250, 16
for i in range(nPtsDAC):
	fpga.set_dac(int(startVal + (i*(455-startVal))/nPtsDAC), mem=i)
```

Now we setup the HILO value, and setting the gain outside of the acquisition window. 

`fpga.set_HILO(hiloVal)`
`fpga.set_dac(dacVal)`

### Running the acquisition

#### Starting to get the enveloppe for 10ms

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
