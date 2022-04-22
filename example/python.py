import spidev 
import time
import RPi.GPIO as GPIO 
import numpy as np
import matplotlib.pyplot as plt 

V = "tmp"

GPIO.setwarnings(False)
GPIO.setmode( GPIO.BCM) 
GPIO.setup(18,GPIO.OUT) #PCM_CLK used as FPGA Reset pin
GPIO.setup(4 ,GPIO.IN)  #HV_EN is high when ADC is acquiring, low if not acquiring (EA_CLK is also having same output)

spi = spidev.SpiDev()
spi.open(0,0)
spi.max_speed_hz = 488000
spi.mode = 3

# Causes a reset of the FPGA
GPIO.output(18, False) 
time.sleep(0.001)
GPIO.output(18, True) 
time.sleep(0.001)
GPIO.output(18, False) 
time.sleep(0.001)

HILO = 0
GAIN = 350

for HILO in [0,1]:
    for GAIN in range(11):
        GAIN = GAIN * 100

        G = 12288 + GAIN*4
        R = G//256
        S = G - 256*R
        print(GAIN,hex(R),hex(S))

        msg  = [0x80,S,0xC0,R,0x40,HILO] #350,0  //DAC 0x3578
        for byt in msg:
            spi.xfer([byt])
        time.sleep(0.0002)


        #print("Bytes received after programming")
        recvData = []
        #print("Reading from memory")
        for addr in range(8192):
            """{TOP_T2,TOP_T1,HV_EN,HILO,ADC_DATA,2'd0}
            ADC_DATA is 10 bits from D11 to D2"""
            spi.xfer([(addr>>8)&0xff,addr&0xff])
            recvData.append(spi.xfer([0x00,0x00]))

        # Rebuilding the sequence
        DAT = [] 
        ar = np.array(recvData)
        for k in range(len(ar)):
            DAT.append( ((ar[:,1][k] & 0b1111)*64) + ((ar[:,0][k]&0b11111100) >>2) )

        # Creating a plot
        plt.figure(figsize=(15,5))
        plt.plot(DAT)
        # Saving the files
        filename = "data/"+V  + "_"+str(HILO)+"_"+str(GAIN)
        np.savez(filename+".npz", V=V, HILO=HILO, GAIN=GAIN, signal=DAT)
        plt.savefig(filename+".jpg")

        time.sleep(0.02)

