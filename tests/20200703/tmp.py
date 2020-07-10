import spidev
import time

WB_ZERO = 0x00
WB_WRITE_ENABLE = 0x06
WB_WRITE_DISABLE = 0x04
WB_CHIP_ERASE = 0xC7
WB_READ_STATUS_REGISTER_1 = 0x05
WB_READ_STATUS_REGISTER_2 = 0x35
WB_READ_DATA = 0x03
WB_READ_PAGE_PROGRAM = 0x02
WB_JEDEC_ID = 0x9F

def connect(bus = 0, device = 1):
        spi = spidev.SpiDev(bus, device)
        spi.open(bus, device)
        return spi

def configure(spi, max_speed_hz = 1953125, mode = 0, bits_per_word = 8):
        spi.max_speed_hz = max_speed_hz
        spi.mode = mode
        spi.bits_per_word = bits_per_word

def print_configuration(spi):
        print "max_speed_hz: %s" % spi.max_speed_hz
        print "mode: %s" % spi.mode
        print "bits_per_word: %s" % spi.bits_per_word

def cs_toggle_high_low(spi):
        spi.cshigh = True;
        spi.cshigh = False;

def cs_toggle_low_high(spi):
        spi.cshigh = False;
        spi.cshigh = True;

def cs_low(spi):
        spi.cshigh = False;

def cs_high(spi):
        spi.cshigh = True;

def transfer(spi, byte):
        return spi.xfer([byte])[0]

def wait_for_device(spi):
        transfer(spi, WB_READ_STATUS_REGISTER_1)
        while(transfer(spi, WB_ZERO) == 1):
                print ".",

def get_jedec_id(spi):
        cs_toggle_high_low(spi)
        transfer(spi, WB_JEDEC_ID)
        manufacturer_id = transfer(spi, WB_ZERO)
        memory_type = transfer(spi, WB_ZERO)
        capacity = transfer(spi, WB_ZERO)
        cs_high(spi);
        wait_for_device(spi)
        return (manufacturer_id, memory_type, capacity)



spi = connect()
configure(spi)
print_configuration(spi)

print get_jedec_id(spi)
