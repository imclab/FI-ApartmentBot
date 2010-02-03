/**
 * FI-ApartmentBot
 * Written By: Matt Fisher
 * http://www.fisherinnovation.com
 */

// Serial
const int SerialSpeed = 9600;         // Serial baud rate

// General
boolean roveMode = false;             // If the robot startup in rover mode or not, also the switch for turning rove mode on and off.
boolean botReady = true;             // Holds back the loop until checks have been verified.
const int roveCheckInterval = 200;    // Time between obstical checks in rover mode.

// Ardumoto
const int PwmPinMotorA = 10;          // Motor A PWM pin
const int PwmPinMotorB = 11;          // Motor B PWM pin
const int DirectionPinMotorA = 12;    // Motor A digital pin
const int DirectionPinMotorB = 13;    // Motor B digital pin

// PING)))
const int pingPin = 7;                // digital pin 7
const int minimumDetectDistance = 3;  // Minimum distance in inches the sensor will allow the robot to come to an obsitcal


void setup() {
  Serial.begin(SerialSpeed);
  Serial.println("FI-ApartmentBot version 0.01");
  Serial.println("Written By: Matt Fisher");
  Serial.println("http://www.fisherinnovation.com");
  Serial.println("---------------------------------");
  Serial.println("");
  
  // init sensors
  //initXbee();       // Xbee
  initArdumoto();   // Motor Controller
  //initADXL();       // Accelerometer
  
  //if(!selfTest()) botReady = false; // Run a selftest on boot.
  //Serial.println("Notice: Robot ready for command...");
}


void loop() {
  if(botReady) {
    if(roveMode) rove(roveCheckInterval);   // The drive time between PING))) checks.
    else readIncommingCommand();            // Watch for user control.
  }
 //monitorPitchAndRoll();
 //delay(500);
}
