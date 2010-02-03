char* motorADirection = ""; // Global var to hold active direction of motor A
char* motorBDirection = ""; // Global var to hold active direction of motor B
int motorACurrentSpeed = 0; // Global var to hold active speed of motor A
int motorBCurrentSpeed = 0; // Global var to hold active speed of motor B

// Roving Configuration
const int spurtDuration = 200;    // The time it takes in ms to run a short burst of spin movement.
const int suprtCheckAmount = 10;  // The amount of checks to run in a spurt test
const int MaxMotorSpeed = 250;    // Max motor speed
const int SpinDuration = 500;	  // The amount of time in ms that is take for the rover to do a 180 degreed turn at MaxMotorSpeed

const int motorStartSpeed = 80;  // The speed the motors start moving the robot
const int powerArcIncrement = 19; // Loop increment for the power arc
const int powerArcDelay = 200;   // Delay in ms for the arc loop


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
    int dirStore = 0; // Store the dir for the power arc.
    
    if(motorDirection == "forward") dir = HIGH;
    else if(motorDirection == "reverse") dir = LOW;
    
    int x = 0; // Power Arc
    
    switch(motor) {
      // Motor A
      case 'a':
        if(motorSpeed == 0) {
          analogWrite(PwmPinMotorA, motorSpeed);
          digitalWrite(DirectionPinMotorA, dir);
          break;
        }
        
        for(x = motorStartSpeed; x < motorSpeed; x++) {
          analogWrite(PwmPinMotorA, motorSpeed);
          digitalWrite(DirectionPinMotorA, dir);
        }
      break;
     
      // Motor B
      case 'b':
        if(motorSpeed == 0) {
          analogWrite(PwmPinMotorB, 0);
          digitalWrite(DirectionPinMotorB, dir);
          break;
        }
        
        for(x = motorStartSpeed; x < motorSpeed; x++) {
          analogWrite(PwmPinMotorB, x);
          digitalWrite(DirectionPinMotorB, dir);
        }
      break;
         
      // Both Motors
      case 'c':
        dirStore = dir; // Store initial direction
        
        if(motorSpeed == 0) {
          stopRover();
          break;
        }
        
        for(x = motorStartSpeed; x < motorSpeed; x++) {
          analogWrite(PwmPinMotorA, x);
          digitalWrite(DirectionPinMotorA, dirStore);
          
          if(dirStore == HIGH) dir = LOW;
          else dir = HIGH;
        
          analogWrite(PwmPinMotorB, x);
          digitalWrite(DirectionPinMotorB, dir);
          
          x = x + powerArcIncrement; // increment
          delay(powerArcDelay); // update delay
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
 * int reverseSpeed = Speed to run the track during the reverse (0 - MaxMotorSpeed)
 * int reverseDuration = Time in ms of reverse duration.
 */
void forward(int fowardSpeed, int forwardDuration = 0) {
  moveMotor('c', "forward", fowardSpeed);
  if(forwardDuration != 0) delay(forwardDuration);
}


/**
 * Reverses the robot for a given duration at a given speed.
 *
 * int reverseSpeed = Speed to run the track during the reverse (0 - MaxMotorSpeed)
 * int reverseDuration = Time in ms of reverse duration.
 */
void reverse(int reverseSpeed, int reverseDuration = 0) {
  moveMotor('c', "reverse", reverseSpeed);
  if(reverseDuration != 0) delay(reverseDuration);
}


/**
 * Turns the robot left by slowing the left motor speed.
 *
 * int turnSpeed = Speed to run the slow track during the turn (inside track) 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void turnLeft(int turnSpeed, int duration = 0) {
  Serial.println("EXEC: MotorControl.turnLeft = speed:");
  Serial.print(turnSpeed);
  Serial.print(" dur:");
  Serial.println(duration);
  
  if(turnSpeed < MaxMotorSpeed) {
    moveMotor('b', "forward", turnSpeed);
    moveMotor('a', "reverse", MaxMotorSpeed);
  }
  
  if(duration != 0 ) delay(duration);
}


/**
 * Turns the robot right by slowing the right motor speed.
 *
 * int turnSpeed = Speed to run the slow track during the turn (inside track) 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void turnRight(int turnSpeed, int duration = 0) {
  Serial.println("EXEC: MotorControl.turnRight = speed:");
  Serial.print(turnSpeed);
  Serial.print(" dur:");
  Serial.println(duration); 
  
  if(turnSpeed < MaxMotorSpeed) {
    moveMotor('a', "forward", MaxMotorSpeed);
    moveMotor('b', "reverse", turnSpeed);
  }
  
  if(duration != 0 ) delay(duration);
}


/**
 * Rotates the rover on the spot in the given direction.
 * 
 * int turnDirection = Direction to spin - 0 = left, 1 = right
 * int turnSpeed = Speed to run the track +/- during the turn. 0 - MaxMotorSpeed
 * int duration = Time in ms to run the turn before going back to straight movement
 */
void spin(int turnDirection, int turnSpeed, int duration = 0) {
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
  } else {
    // Right
    moveMotor('a', "forward", MaxMotorSpeed);
    moveMotor('b', "reverse", MaxMotorSpeed);
  }
  
  if(duration != 0) delay(duration);
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
