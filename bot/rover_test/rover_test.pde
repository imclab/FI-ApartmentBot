/*
  Test program to get autonomous travel function into the rover.
  Using Ultrasonic Range Finders (PING)))), we can detect obsitcals and avoid hitting them. 
  As we travel we send our X and Y location to the server to track us.
*/

#define PwmPinMotorA 10
#define PwmPinMotorB 11
#define DirectionPinMotorA 12
#define DirectionPinMotorB 13
#define SerialSpeed 9600

const int MaxMotorSpeed = 175; // 70% capibility
const int pingPin = 7;         // PING))) on digital pin 7


void setup() {
  Serial.begin(SerialSpeed);
  initArdumoto();
}


void loop() {
  drive();
}


/**
 * Sets up the pinModes to the Ardumoto controller.
 */
void initArdumoto() {
  // motor pins must be outputs
  pinMode(PwmPinMotorA, OUTPUT);
  pinMode(PwmPinMotorB, OUTPUT);
  pinMode(DirectionPinMotorA, OUTPUT);
  pinMode(DirectionPinMotorB, OUTPUT); 
}


/**
 * Reads the PING))) sensor & returns the distance in inches.
 */
long readPing() {
  // establish variables for duration of the ping, 
  // and the distance result in inches and centimeters:
  long duration, inches;//, cm;

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
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  //cm = microsecondsToCentimeters(duration);

  return inches;
}


/**
 * According to Parallax's datasheet for the PING))), there are
 * 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
 * second).  This gives the distance travelled by the ping, outbound
 * and return, so we divide by 2 to get the distance of the obstacle.
 * See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
 */
long microsecondsToInches(long microseconds) {
  return microseconds / 74 / 2;
}


/**
 * The speed of sound is 340 m/s or 29 microseconds per centimeter.
 * The ping travels out and back, so to find the distance of the
 * object we take half of the distance travelled.
 */
//long microsecondsToCentimeters(long microseconds) {
//  return microseconds / 29 / 2;
//}


/**
 * Moves the rover.
 */
void drive() {
  // Start by checking if anything is infront of us (3 inches)
  if(readPing() < 3) {
    stopRover();
    
    // Select a random direction to turn
    if(random(0, 2) == 0) {
      // Go left
    } else {
      // Go right
    }  
  }
}


/**
 * Turns the robot left by slowing the left motor speed.
 */
void turnLeft(int turnSpeed, int duration) {
  if(turnSpeed < MaxMotorSpeed) {
    // motor A forwards
    analogWrite(PwmPinMotorA, turnSpeed);
    digitalWrite(DirectionPinMotorA, HIGH);
  
    // motor B forwards
    analogWrite(PwmPinMotorB, MaxMotorSpeed);
    digitalWrite(DirectionPinMotorB, LOW);  
  }
  
  delay(duration);
}


/**
 * Turns the robot right by slowing the right motor speed.
 */
void turnRight(int turnSpeed, int duration) {
  if(turnSpeed < MaxMotorSpeed) {
    // motor A forwards
    analogWrite(PwmPinMotorA, MaxMotorSpeed);
    digitalWrite(DirectionPinMotorA, HIGH);
  
    // motor B forwards
    analogWrite(PwmPinMotorB, turnSpeed);
    digitalWrite(DirectionPinMotorB, LOW);  
  }
  
  delay(duration);
}


/**
 * Rotates the rover on the spot in the given direction.
 * turnDirection: 0 = left, 1 = right
 */
void spin(int turnDirection, int turnSpeed, int duration) {
  if(turnDirection == 0) {
    // left 
    // motor A reverse
    analogWrite(PwmPinMotorA, turnSpeed);
    digitalWrite(DirectionPinMotorA, LOW);
    
    // motor B forwards
    analogWrite(PwmPinMotorB, MaxMotorSpeed);
    digitalWrite(DirectionPinMotorB, LOW);
  } else {
    // right
    // motor A forwards
    analogWrite(PwmPinMotorA, MaxMotorSpeed);
    digitalWrite(DirectionPinMotorA, HIGH);
    
    // motor B reverse
    analogWrite(PwmPinMotorB, turnSpeed);
    digitalWrite(DirectionPinMotorB, HIGH);
  }
  
  delay(duration);
}


/**
 * Stops the movement of the motors.
 */
void stopRover() {
  // motor A
  analogWrite(PwmPinMotorA, 0);
  digitalWrite(DirectionPinMotorA, LOW);
  
  // motor B
  analogWrite(PwmPinMotorB, 0);
  digitalWrite(DirectionPinMotorB, LOW);
}
