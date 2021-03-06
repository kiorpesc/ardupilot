// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-
//
// Test for AP_GPS_AUTO
//

#include <stdlib.h>

#include <AP_Common.h>
#include <AP_Progmem.h>
#include <AP_Param.h>
#include <AP_HAL.h>
#include <AP_HAL_AVR.h>
#include <AP_HAL_AVR_SITL.h>
#include <AP_HAL_PX4.h>
#include <AP_HAL_Empty.h>
#include <AP_GPS.h>
#include <DataFlash.h>
#include <AP_InertialSensor.h>
#include <AP_ADC.h>
#include <GCS_MAVLink.h>
#include <AP_Baro.h>
#include <Filter.h>
#include <AP_AHRS.h>
#include <AP_Compass.h>
#include <AP_Declination.h>
#include <AP_Airspeed.h>
#include <AP_Vehicle.h>
#include <AP_ADC_AnalogSource.h>
#include <AP_Mission.h>
#include <AP_Math.h>
#include <AP_Notify.h>
#include <AP_BoardLED.h>

const AP_HAL::HAL& hal = AP_HAL_BOARD_DRIVER;

// create board led object
AP_BoardLED board_led;

GPS         *gps;
AP_GPS_Auto GPS(&gps);

#define T6 1000000
#define T7 10000000

void setup()
{
    hal.uartB->begin(38400);

    hal.console->println("GPS AUTO library test");
    gps = &GPS;
    gps->init(hal.uartB, GPS::GPS_ENGINE_AIRBORNE_4G, NULL);

    // initialise the leds
    board_led.init();
}

void loop()
{
    gps->update();
    if (gps->new_data) {
        if (gps->fix) {
            hal.console->print("Lat: ");
            print_latlon(hal.console,gps->latitude);
            hal.console->print(" Lon: ");
            print_latlon(hal.console,gps->longitude);
            hal.console->printf(" Alt: %.2fm GSP: %.2fm/s CoG: %d SAT: %d TIM: %u/%lu STATUS: %u\n",
                          (float)gps->altitude_cm / 100.0,
                          (float)gps->ground_speed_cm / 100.0,
                          (int)gps->ground_course_cd / 100,
                          gps->num_sats,
                          gps->time_week,
                          gps->time_week_ms,
                          gps->status());
        } else {
            hal.console->println("No fix");
        }
        gps->new_data = false;
    }
}

AP_HAL_MAIN();
