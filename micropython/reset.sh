#!/usr/bin/env bash

gpio mode 6 OUT
gpio write 6 0 
sleep 0.1
gpio write 6 1
