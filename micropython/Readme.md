# Install

Execute

```
./creset.sh
./flash_firmware.sh
./flash_picosoc.sh
./reset

```

and to connect

```
sudo picocom -b9600 /dev/ttyS0
```


[On RPi4](https://www.editions-eni.fr/open/mediabook.aspx?idR=95a74a203820b0ab4eb45008abcaa14f)

Serial needs to be activated, but not to get a shell to the Pi, using raspi-config.

To activate UART 5, one needs to add the following to `/boot/config.txt` :

`
enable_uart=1 
dtoverlay=uart5
`
