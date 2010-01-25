/*
  Test program to get autonomous travel function into the rover.
  Using Ultrasonic Range Finders (PING)))), we can detect obsitcals and avoid hitting them.
  Using a ADXL3xx Accelerometer we can detect if we are prone to tipping/rolling over.
  As we travel we send our X and Y location to the server to track us.
*/

const int SerialSpeed = 9600;         // Serial baud rate

// Ardumoto
const int PwmPinMotorA = 10;
const int PwmPinMotorB = 11;
const int DirectionPinMotorA = 12;
const int DirectionPinMotorB = 13;
const int MaxMotorSpeed = 175;        // 70% capibility
const int SpinDuration = 500;		  // The amount of time in ms that is take for the rover to do a 180 degreed turn at MaxMotorSpeed
char* motorADirection = "";           // Global var to hold active direction of motor A
char* motorBDirection = "";           // Global var to hold active direction of motor B
int motorACurrentSpeed = 0;           // Global var to hold active speed of motor A
int motorBCurrentSpeed = 0;           // Global var to hold active speed of motor B

// PING)))
const int pingPin = 7;                // digital pin 7

// ADXL3xx Accelerometer
#define sampleSize 8                  // MUST be a multiple of 2, see later for why
#define shiftBits 3                   // sampleSize = 2 ^ shiftBits
const int ADXLxpin = 1;               // x-axis analog ping 3
const int ADXLypin = 2;               // y-axis analog ping 2
const int ADXLzpin = 3;               // z-axis analog ping 1
static int startVal = 512;            // I picked startVal somewhat arbitrariliy.  What you probably should do is read the sensor in setup(), do some calibrations by turning the sensor on and off with the reset pin (ST), and pick a good starting value.
int curSamp = 0;
int xVal = 0;
int yVal = 0;
int zVal = 0;
int xVals[sampleSize];
int yVals[sampleSize];
int zVals[sampleSize];
int xAvg = 0;
int yAvg = 0;
int zAvg = 0;
int xPreAvg = 0;
int yPreAvg = 0;
int zPreAvg = 0;

// IR Config
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
unsigned long timer_irs = 0;
unsigned int IR_cnt[4];
byte ir_compare=0;


void setup() {
  Serial.begin(SerialSpeed);
  initArdumoto();              // Init the motor controller
  initADXL();                  // Init the accelerometer
  Init_IRs();
}


void loop() {
  rove();
  delay(200); // The drive time between PING))) checks.
}


/**
 * Attempts to calculate where the robot has been.
 */
void trackProgress() {
  Serial.println("EXEC: trackProgress");

  // TODO: figure out how to calculate this.
}


/**
 * Attempts to find the docking station to recharge the power system.
 * The station holds a infared LED array which we will attempt to locate, confirm and approach.
 *
 * Pololu IR Beacon Transceiver Pair
 */
void findHome() {
  read_irs();        // Capture IR packets..
  analyse_irs(500);  // After 500 millisecon will analyse the packets captured
}


