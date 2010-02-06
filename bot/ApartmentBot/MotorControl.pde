// Roving Configuration
const int spurtDuration = 200;    // The time it takes in ms to run a short burst of spin movement.
const int suprtCheckAmount = 10;  // The amount of checks to run in a spurt test
const int MaxMotorSpeed = 250;    // Max motor speed
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
  if(motorSpeed <= MaxMotorSpeed) {
    int dir = 0;
    
    if(motor == 'a') {
       if(motorDirection == "forward") dir = HIGH;
       else if(motorDirection == "reverse" || motorDirection == "backwards") dir = LOW;
    } else if(motor == 'b') {
       if(motorDirection == "forward") dir = LOW;
       else if(motorDirection == "reverse" || motorDirection == "backwards") dir = HIGH;
    }
    
    switch(motor) {
      case 'a':
        analogWrite(PwmPinMotorA, motorSpeed);
        digitalWrite(DirectionPinMotorA, dir);
      break;
     
      case 'b':
        analogWrite(PwmPinMotorB, motorSpeed);
        digitalWrite(DirectionPinMotorB, dir);
      break;
         
      case 'c':
        if(motorDirection == "forward") {
          analogWrite(PwmPinMotorA, motorSpeed);
          digitalWrite(DirectionPinMotorA, HIGH);
            
          analogWrite(PwmPinMotorB, motorSpeed);
          digitalWrite(DirectionPinMotorB, LOW);
        } else {
          analogWrite(PwmPinMotorA, motorSpeed);
          digitalWrite(DirectionPinMotorA, LOW);
            
          analogWrite(PwmPinMotorB, motorSpeed);
          digitalWrite(DirectionPinMotorB, HIGH);
        }
      break;  
    }
  } else {
    Serial.println("ERROR: MotorControl.moveMotor: Supplied motorSpeed was out of bounds.");
  }
}


/**
 * Reverses the robot for a given duration at a given speed.
 *
 * int fspeed = Speed to run the track during the reverse (0 - MaxMotorSpeed)
 * int duration = Time in ms of reverse duration.
 */
void forward(int fspeed, int duration = 0) {
  moveMotor('c', "forward", fspeed);
  checkDuration(duration);
}


/**
 * Reverses the robot for a given duration at a given speed.
 *
 * int rspeed = Speed to run the track during the reverse (0 - MaxMotorSpeed)
 * int duration = Time in ms of reverse duration.
 */
void reverse(int rspeed, int duration = 0) {
  moveMotor('c', "reverse", rspeed);
  checkDuration(duration);
}


/**
 * Turns the robot left by slowing the left motor speed.
 *
 * int turnSpeed = Speed to run the slow track during the turn (inside track) 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void turnLeft(int turnSpeed, int duration = 0) {
  if(turnSpeed < MaxMotorSpeed) {
    moveMotor('b', "forward", turnSpeed);
    moveMotor('a', "reverse", MaxMotorSpeed);
  }
  
  checkDuration(duration);
}


/**
 * Turns the robot right by slowing the right motor speed.
 *
 * int turnSpeed = Speed to run the slow track during the turn (inside track) 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void turnRight(int turnSpeed, int duration = 0) {
  if(turnSpeed < MaxMotorSpeed) {
    moveMotor('a', "forward", MaxMotorSpeed);
    moveMotor('b', "reverse", turnSpeed);
  }
  checkDuration(duration);
}


/**
 * Rotates the rover on the spot in the given direction.
 * 
 * int turnDirection = Direction to spin - 0 = left, 1 = right
 * int turnSpeed = Speed to run the track +/- during the turn. 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void spin(int turnDirection, int turnSpeed, int duration = 0) {
  if(turnDirection == 0) {
    moveMotor('a', "reverse", turnSpeed);
    moveMotor('b', "forward", turnSpeed);
  } else {
    moveMotor('a', "forward", turnSpeed);
    moveMotor('b', "reverse", turnSpeed);
  }
  
  checkDuration(duration);
}


/**
 * Stops the movement of the motors.
 */
void stopRover() {
  analogWrite(PwmPinMotorA, 0);
  digitalWrite(DirectionPinMotorA, LOW);
  
  analogWrite(PwmPinMotorB, 0);
  digitalWrite(DirectionPinMotorB, LOW);
}


/**
 * Stops the rover after a given duration.
 */
void checkDuration(int duration) {
  if(duration != 0) {
    delay(duration);
    stopRover();
  }
}
