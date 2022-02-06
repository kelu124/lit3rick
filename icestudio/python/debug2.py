import spidev
import numpy
import time
import RPi.GPIO as GPIO 

GPIO.setwarnings(False)
GPIO.setmode( GPIO.BCM) 
GPIO.setup(18,GPIO.OUT) #PCM_CLK
GPIO.setup(4 ,GPIO.IN)  #HV_EN

spi = spidev.SpiDev()
spi.open(0,0)
spi.max_speed_hz = 500000
spi.mode = 0

#GPIO.output(18, False) 
#print(GPIO.input(4))
print(spi.xfer([0,0]))

print(spi.xfer([128,192]))

#GPIO.output(18, True) 
#print(GPIO.input(4))
print(spi.xfer([32,2]))
