/*
  Test program to get autonomous travel function into the rover.
  Using Ultrasonic Range Finders (PING)))), we can detect obsitcals and avoid hitting them.
  Using a ADXL3xx Accelerometer we can detect if we are prone to tipping/rolling over. 
  As we travel we send our X and Y location to the server to track us.
*/

// Ardumoto
const int PwmPinMotorA = 10;
const int PwmPinMotorB = 11;
const int DirectionPinMotorA = 12;
const int DirectionPinMotorB = 13;
const int SerialSpeed = 9600;         // Serial baud rate
const int MaxMotorSpeed = 175;        // 70% capibility
char* motorADirection = "";           // Global var to hold active direction of motor A
char* motorBDirection = "";           // Global var to hold active direction of motor B
int motorACurrentSpeed = 0;           // Global var to hold active speed of motor A
int motorBCurrentSpeed = 0;           // Global var to hold active speed of motor B

// PING)))
const int pingPin = 7;                // digital pin 7

// ADXL3xx Accelerometer
#define sampleSize 8                  // MUST be a multiple of 2, see later for why
#define shiftBits 3                   // sampleSize = 2 ^ shiftBits
const int ADXLxpin = 3;               // x-axis analog ping 3
const int ADXLypin = 2;               // y-axis analog ping 2
const int ADXLzpin = 1;               // z-axis analog ping 1
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


void setup() {
  Serial.begin(SerialSpeed);
  initArdumoto();
  initADXL();
}


void loop() {
  rove();
  delay(200); // The drive time between PING))) checks.
}


/**
 * Sets up the pinModes to the Ardumoto controller.
 */
void initArdumoto() {
  Serial.println("EXEC: initArdumoto");
  
  pinMode(PwmPinMotorA, OUTPUT);
  pinMode(PwmPinMotorB, OUTPUT);
  pinMode(DirectionPinMotorA, OUTPUT);
  pinMode(DirectionPinMotorB, OUTPUT); 
}


/**
 * Sets up the pinModes to the ADXLxx Accelerometer .
 */
void initADXL() {
  Serial.println("EXEC: initADXL");
  
  pinMode(ADXLxpin, INPUT);
  pinMode(ADXLypin, INPUT);
  pinMode(ADXLzpin, INPUT);
  
  for (int i=0; i < sampleSize; i++) {
    xVals[i] = startVal;
    xVals[i] = startVal;
    zVals[i] = startVal;
  }
}


/**
 * Reads the PING))) sensor & returns the distance in inches.
 */
long readPing() {
  Serial.println("EXEC: readPing");
  
  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);
  
  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  long duration = pulseIn(pingPin, HIGH);

  return microsecondsToInches(duration);
}


/**
 * According to Parallax's datasheet for the PING))), there are
 * 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
 * second).  This gives the distance travelled by the ping, outbound
 * and return, so we divide by 2 to get the distance of the obstacle.
 * See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
 */
long microsecondsToInches(long microseconds) {
  Serial.println("EXEC: microsecondsToInches");
  return microseconds / 74 / 2;
}


/**
 * Moves a given motor a gven direction at a given speed.
 *
 * char motor = The motor to move (a = motorA, b = motorB, c = both motors).
 * char* motorDirection = Direction to run the motor ("forward" or "reverse").
 * int motorSpeed = Speed to run the motor (0 - MaxMotorSpeed)
 */
void moveMotor(char motor, char* motorDirection, int motorSpeed) {
  Serial.println("EXEC: moveMotor");
  
  int dir = 0;
  
  if(motorDirection == "forward") dir = HIGH;
  else if(motorDirection == "reverse") dir = LOW;
  
  switch(motor) {
    // Motor A
    case 'a':
      analogWrite(PwmPinMotorA, motorSpeed);
      digitalWrite(DirectionPinMotorA, dir);
      motorACurrentSpeed = motorSpeed;
      motorADirection = motorDirection;
    break;
   
    // Motor B
    case 'b':
      analogWrite(PwmPinMotorB, motorSpeed);
      digitalWrite(DirectionPinMotorB, dir);
      motorBCurrentSpeed = motorSpeed;
      motorBDirection = motorDirection;
    break;
       
    // Both Motors
    case 'c':
      analogWrite(PwmPinMotorA, motorSpeed);
      digitalWrite(DirectionPinMotorA, dir);
      motorACurrentSpeed = motorSpeed;
      motorADirection = motorDirection;
    
      analogWrite(PwmPinMotorB, motorSpeed);
      digitalWrite(DirectionPinMotorB, dir);
      motorBCurrentSpeed = motorSpeed;
      motorBDirection = motorDirection;
    break;  
  }
} 


/**
 * Moves the rover.
 */
void rove() {
  Serial.println("EXEC: rove");
  
  monitorPitchAndRoll();  // Make sure we aren't going to tip over.
  
  // Start by checking if anything is infront of us (3 inches)
  if(readPing() < 3) {
    stopRover();
    
    // Select a random direction to turn
    if(random(0, 2) == 0)
      spin(0, MaxMotorSpeed * 0.8, 1000); // Spin left
    else
      spin(1, MaxMotorSpeed * 0.8, 1000); // Spin right
  } else moveMotor('c', "forward", MaxMotorSpeed); // Move forward.
}


/**
 * Turns the robot left by slowing the left motor speed.
 *
 * int turnSpeed = Speed to run the slow track during the turn (inside track) 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void turnLeft(int turnSpeed, int duration) {
  Serial.println("EXEC: turnLeft = speed:");
  Serial.print(turnSpeed);
  Serial.print(" dur:");
  Serial.println(duration);
  
  if(turnSpeed < MaxMotorSpeed) {
    moveMotor('a', "forward", turnSpeed);
    moveMotor('a', "reverse", MaxMotorSpeed);
  }
  
  delay(duration);
}


/**
 * Turns the robot right by slowing the right motor speed.
 *
 * int turnSpeed = Speed to run the slow track during the turn (inside track) 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void turnRight(int turnSpeed, int duration) {
  Serial.println("EXEC: turnRight = speed:");
  Serial.print(turnSpeed);
  Serial.print(" dur:");
  Serial.println(duration); 
  
  if(turnSpeed < MaxMotorSpeed) {
    moveMotor('a', "forward", MaxMotorSpeed);
    moveMotor('b', "reverse", turnSpeed);
  }
  
  delay(duration);
}


/**
 * Rotates the rover on the spot in the given direction.
 * 
 * int turnDirection = Direction to spin - 0 = left, 1 = right
 * int turnSpeed = Speed to run the track +/- during the turn. 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void spin(int turnDirection, int turnSpeed, int duration) {
  Serial.print("EXEC: spin = dir:");
  Serial.print(turnDirection);
  Serial.print(" speed:");
  Serial.print(turnSpeed);
  Serial.print(" dur:");
  Serial.println(duration);
  
  if(turnDirection == 0) {
    // Left 
    moveMotor('a', "reverse", MaxMotorSpeed);
    moveMotor('b', "forward", MaxMotorSpeed);
    // motor B forwards
  } else {
    // Right
    moveMotor('a', "forward", MaxMotorSpeed);
    moveMotor('b', "reverse", MaxMotorSpeed);
  }
  
  delay(duration);
}


/**
 * Stops the movement of the motors.
 */
void stopRover() {
  Serial.println("EXEC: stopRover");
  
  // motor A
  analogWrite(PwmPinMotorA, 0);
  digitalWrite(DirectionPinMotorA, LOW);
  
  // motor B
  analogWrite(PwmPinMotorB, 0);
  digitalWrite(DirectionPinMotorB, LOW);
}


/**
 * Attempts to calculate where the robot has been.
 */ 
void trackProgress() {
  Serial.println("EXEC: trackProgress");
  
  // TODO: figure out how to calculate this.
}


/**
 * Monitors a ADXL3xx accelerometer and checks if the rover is close to tipping over.
 */ 
void monitorPitchAndRoll() {
  Serial.println("EXEC: monitorPitchAndRoll");
  
  // We use curSamp as an index into the array and increment at the
  // end of the main loop(), so see if we need to reset it at the
  // very start of the loop
  if (curSamp == sampleSize) curSamp = 0;

  xVal = analogRead(ADXLxpin);
  yVal = analogRead(ADXLypin);
  zVal = analogRead(ADXLzpin);

  xVals[curSamp] = xVal;
  yVals[curSamp] = yVal;
  zVals[curSamp] = zVal;
  
  xPreAvg = xAvg;
  yPreAvg = yAvg;
  zPreAvg = zAvg;
  
  xAvg = 0;
  yAvg = 0;
  zAvg = 0;
  
  for (int i=0; i < sampleSize; i++) {
	xAvg += xVals[i];
	yAvg += yVals[i];
	zAvg += zVals[i];
  }
  
  // For those who didn't grow up on C, "x >> y" is a way of saying
  // shift the bits in variable x y bits to the right, effectively
  // dividing by 2 and losing the remainder.  1 bit is in half, 2
  // bits is 1/4, and so on.  It's much faster than using the divide
  // operator "/" if you're working with powers of 2.  (Ok, so a
  // good compiler would optimize that for you, but this is just in
  // case.)
  xAvg = (xAvg >> shiftBits);
  yAvg = (yAvg >> shiftBits);
  zAvg = (zAvg >> shiftBits);
  
  Serial.print(xPreAvg);
  Serial.print(" ");
  Serial.print(xAvg);
  Serial.print(" ");
  Serial.print(xVal);
  Serial.print(" | ");
  Serial.print(yPreAvg);
  Serial.print(" ");
  Serial.print(yAvg);
  Serial.print(" ");
  Serial.print(yVal);
  Serial.print(" | ");
  Serial.print(zPreAvg);
  Serial.print(" ");
  Serial.print(zAvg);
  Serial.print(" ");
  Serial.println(zVal);

  curSamp++;  // increment our array pointer
}
