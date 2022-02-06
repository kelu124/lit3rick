import spidev
import numpy
import time
import RPi.GPIO as GPIO 

GPIO.setwarnings(False)
GPIO.setmode( GPIO.BCM) 
GPIO.setup(18,GPIO.OUT) #PCM_CLK
GPIO.setup(4 ,GPIO.IN)  #HV_EN

GPIO.output(18, False) 
GPIO.output(18, True) 
time.sleep(0.1)
GPIO.output(18, False) 
time.sleep(0.001)

print("Pollong HV_EN for any changes")
recvData1 = GPIO.input(4)
print(recvData1)
while 1:
    recvData2 = GPIO.input(4)
    if recvData1!=recvData2:
        print(recvData2)
    recvData1=recvData2

#spi = spidev.SpiDev()
#spi.open(0,0)
#spi.max_speed_hz = 500000
#spi.mode = 0

#print("Pollong SPI Read for any changes")
#recvData1 = spi.xfer([0x00,0x00])
#print(recvData1)
#while 1:
#    recvData2 = spi.xfer([0x00,0x00])
#    if recvData1!=recvData2:
#        print(recvData2)
#    recvData1=recvData2