char* motorADirection = ""; // Global var to hold active direction of motor A
char* motorBDirection = ""; // Global var to hold active direction of motor B
int motorACurrentSpeed = 0; // Global var to hold active speed of motor A
int motorBCurrentSpeed = 0; // Global var to hold active speed of motor B

// Roving Configuration
const int spurtDuration = 200;    // The time it takes in ms to run a short burst of spin movement.
const int suprtCheckAmount = 10;  // The amount of checks to run in a spurt test
const int MaxMotorSpeed = 175;    // 70% capibility
const int SpinDuration = 500;	  // The amount of time in ms that is take for the rover to do a 180 degreed turn at MaxMotorSpeed


/**
 * Sets up the pinModes to the Ardumoto controller.
 */
void initArdumoto() {
  Serial.println("EXEC: MotorControl.initArdumoto");
  
  pinMode(PwmPinMotorA, OUTPUT);
  pinMode(PwmPinMotorB, OUTPUT);
  pinMode(DirectionPinMotorA, OUTPUT);
  pinMode(DirectionPinMotorB, OUTPUT); 
}


/**
 * Moves a given motor a gven direction at a given speed.
 *
 * char motor = The motor to move (a = motorA, b = motorB, c = both motors).
 * char* motorDirection = Direction to run the motor ("forward" or "reverse").
 * int motorSpeed = Speed to run the motor (0 - MaxMotorSpeed)
 */
void moveMotor(char motor, char* motorDirection, int motorSpeed) {
  Serial.println("EXEC: MotorControl.moveMotor");
  
  if(motorSpeed <= MaxMotorSpeed) {
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
  } else {
    Serial.println("ERROR: MotorControl.moveMotor: Supplied motorSpeed was out of bounds.");  
  }
}


/**
 * Reverses the robot for a given duration at a given speed.
 *
 * int reverseSpeed = Speed to run the track during the reverse (0 - MaxMotorSpeed)
 * int reverseDuration = Time in ms of reverse duration.
 */
void forward(int fowardSpeed, int forwardDuration) {
  moveMotor('c', "forward", fowardSpeed);
  delay(forwardDuration);
}


/**
 * Reverses the robot for a given duration at a given speed.
 *
 * int reverseSpeed = Speed to run the track during the reverse (0 - MaxMotorSpeed)
 * int reverseDuration = Time in ms of reverse duration.
 */
void reverse(int reverseSpeed, int reverseDuration) {
  moveMotor('c', "reverse", reverseSpeed);
  delay(reverseDuration);
}


/**
 * Turns the robot left by slowing the left motor speed.
 *
 * int turnSpeed = Speed to run the slow track during the turn (inside track) 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void turnLeft(int turnSpeed, int duration) {
  Serial.println("EXEC: MotorControl.turnLeft = speed:");
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
  Serial.println("EXEC: MotorControl.turnRight = speed:");
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
  Serial.print("EXEC: MotorControl.spin = dir:");
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
  Serial.println("EXEC: MotorControl.stopRover");
  
  // motor A
  analogWrite(PwmPinMotorA, 0);
  digitalWrite(DirectionPinMotorA, LOW);
  
  // motor B
  analogWrite(PwmPinMotorB, 0);
  digitalWrite(DirectionPinMotorB, LOW);
}
