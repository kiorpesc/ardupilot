#include <AP_HAL.h>

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <linux/types.h>
#include <linux/spi/spidev.h>


#if CONFIG_HAL_BOARD == HAL_BOARD_LINUX

#include "GPIO.h"

using namespace Linux;

LinuxGPIO::LinuxGPIO()
    _fd(-1)
{}

void LinuxGPIO::init()
{
    _fd = open("/sys/class/gpio/gpio9/value", O_RDWR);
}

void LinuxGPIO::pinMode(uint8_t pin, uint8_t output)
{
// set pin mode?
}

int8_t LinuxGPIO::analogPinToDigitalPin(uint8_t pin)
{
	return -1;
}


uint8_t LinuxGPIO::read(uint8_t pin) {
    char val = read(_fd, 1);
    return 0;
}

void LinuxGPIO::write(uint8_t pin, uint8_t value)
{
    int ret = write(fd, (void*)(&value), 1);
}

void LinuxGPIO::toggle(uint8_t pin)
{
 // use file write
}

/* Alternative interface: */
AP_HAL::DigitalSource* LinuxGPIO::channel(uint16_t n) {
    return new LinuxDigitalSource(0);
}

/* Interrupt interface: */
bool LinuxGPIO::attach_interrupt(uint8_t interrupt_num, AP_HAL::Proc p,
        uint8_t mode) {
    return true;
}

bool LinuxGPIO::usb_connected(void)
{
    return false;
}

LinuxDigitalSource::LinuxDigitalSource(uint8_t v) :
    _v(v)
{}

void LinuxDigitalSource::mode(uint8_t output)
{
// set mode?
}

uint8_t LinuxDigitalSource::read() {
    // can't use files again?
    return _v;
}

void LinuxDigitalSource::write(uint8_t value) {
    _v = value;
}

void LinuxDigitalSource::toggle() {
    _v = !_v;
}

#endif // CONFIG_HAL_BOARD
