
USBMODE ?= 0
GPIOMODE ?= 0

ifeq ($(shell bash -c 'type -p icoprog'),)
SSH_RASPI ?= ssh pi@raspi
else
SSH_RASPI ?= sh -c
endif

	gcc -o ifoprog -Wall -Os icoprog.cc -lwiringPi -lrt -lstdc++

