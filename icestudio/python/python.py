import spidev 
import time
import RPi.GPIO as GPIO 
import numpy as np
import matplotlib.pyplot as plt 

GPIO.setwarnings(False)
GPIO.setmode( GPIO.BCM) 
GPIO.setup(18,GPIO.OUT) #PCM_CLK used as FPGA Reset pin
GPIO.setup(4 ,GPIO.IN)  #HV_EN is high when ADC is acquiring, low if not acquiring (EA_CLK is also having same output)

spi = spidev.SpiDev()
spi.open(0,0)
spi.max_speed_hz = 488000
spi.mode = 3

GPIO.output(18, False) 
time.sleep(0.001)
GPIO.output(18, True) 
time.sleep(0.001)
GPIO.output(18, False) 
time.sleep(0.001)

print(GPIO.input(4))

#msg = [0x80,0xBC,0xC0,0x31,0x40,0x00] #111
#msg = [0x80,0xC3,0xC0,0x3C,0x40,0x00] #819
#msg = [0x80,0xC3,0xC0,0x3C,0x40,0x01] #819 //0x01 at last byte sets HILO to 1
#msg = [0x80,0xC3,0xC0,0x3C,0x40,0x00] #819 //0x00 at last byte sets HILO to 0
#msg = [0x80,0x00,0xC0,0x30,0x40,0x00] #0,0    //DAC 0x3000
#msg = [0x80,0x00,0xC0,0x30,0x40,0x01] #0,1    //DAC 0x3000
#msg = [0x80,0x78,0xC0,0x35,0x40,0x00] #350,0  //DAC 0x3578
#msg = [0x80,0x78,0xC0,0x35,0x40,0x01] #350,1  //DAC 0x3578
#msg = [0x80,0xF0,0xC0,0x3A,0x40,0x00] #700,0  //DAC 0x3AF0
#msg = [0x80,0xF0,0xC0,0x3A,0x40,0x01] #700,1  //DAC 0x3AF0
#msg = [0x80,0xA0,0xC0,0x3F,0x40,0x00] #1000,0  //DAC 0x3FA0
msg = [0x80,0xA0,0xC0,0x3F,0x40,0x01] #1000,1  //DAC 0x3FA0
for byt in msg:
    spi.xfer([byt])

print(GPIO.input(4))
print(GPIO.input(4))

time.sleep(0.0002)

print(GPIO.input(4))

#print("Bytes received after programming")
recvData = []
#print("Reading from memory")
for addr in range(8192):
    """{TOP_T2,TOP_T1,HV_EN,HILO,ADC_DATA,2'd0}
    ADC_DATA is 10 bits from D11 to D2"""
    spi.xfer([(addr>>8)&0xff,addr&0xff])
    recvData.append(spi.xfer([0x00,0x00]))

print("data =",recvData[1:10],";")
print("data =",recvData[8183:8192],";")
ar = np.array(recvData)

DAT = [] 
for k in range(len(ar)):
    DAT.append( ((ar[:,1][k] & 0b1111)*64) + ((ar[:,0][k]&0b11111100) >>2) )

plt.figure(figsize=(15,5))
plt.plot(DAT)
plt.savefig("img_1000_1.jpg")

print("data =",ar[1,0],";")
print("data =",ar[1,1],";")
print("data =",DAT[1],";")