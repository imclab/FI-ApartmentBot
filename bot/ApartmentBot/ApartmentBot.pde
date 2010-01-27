/**
** FI-ApartmentBot
** Written By: Matt Fisher
** http://www.FisherInnovation.com
**/

//#include <XBee.h>
//#include <Servo.h>

// Serial
const int SerialSpeed = 9600;         // Serial baud rate

// General
boolean roveMode = true;              // If the robot startup in rover mode or not, also the switch for turning rove mode on and off.
boolean botReady = false;             // Holds back the loop until checks have been verified.
const int roveCheckInterval = 200;    // Time between obstical checks in rover mode.

// Ardumoto
const int PwmPinMotorA = 10;          // Motor A PWM pin
const int PwmPinMotorB = 11;          // Motor B PWM pin
const int DirectionPinMotorA = 12;    // Motor A digital pin
const int DirectionPinMotorB = 13;    // Motor B digital pin

// PING)))
const int pingPin = 7;                // digital pin 7
const int minimumDetectDistance = 3;  // Minimum distance in inches the sensor will allow the robot to come to an obsitcal

// ADXL3xx Accelerometer
const int maxRoll = 45;               // Max allowance in roll before tip correction (degrees)
const int maxPitch = 45;              // Max allowance in pitch before tip correction (degrees)
const int ADXLxpin = 1;               // x-axis analog ping 3
const int ADXLypin = 2;               // y-axis analog ping 2
const int ADXLzpin = 3;               // z-axis analog ping 1

// IR Beacon Config
const int IR_FRONT = 8;
const int IR_BACK = 7;
const int IR_RIGHT = 6;
const int IR_LEFT = 9;
const int led_north = 12;
const int led_east = 17;
const int led_south = 11;
const int led_west = 13;
const int led_delay = 150;
const int led_cycles = 2;


void setup() {
  Serial.begin(SerialSpeed);
  
  // init sensors
  initXbee();       // Xbee
  initArdumoto();   // Motor Controller
  initADXL();       // Accelerometer
  initIRs();        // IR sensors for docking station
  
  if(!selfTest()) botReady = false; // Run a selftest on boot.
}


void loop() {
  if(botReady) {
    // Start autonomous roving pending the switch is on.
    if(roveMode) rove(roveCheckInterval); // The drive time between PING))) checks.
    else {
      // TODO: setup wireless control 
    }
  }
}
