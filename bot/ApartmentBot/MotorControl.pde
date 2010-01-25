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
      spin(0, MaxMotorSpeed * 0.8, 500); // Spin left
    else
      spin(1, MaxMotorSpeed * 0.8, 500); // Spin right
  } else moveMotor('c', "forward", MaxMotorSpeed); // Move forward.
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
    Serial.println("ERROR: moveMotor: Supplied motorSpeed was out of bounds.");  
  }
}


/**
 * Reverses the robot for a given duration at a given speed.
 *
 * int reverseSpeed = Speed to run the track during the reverse (0 - MaxMotorSpeed)
 * int reverseDuration = Time in ms of reverse duration.
 */
void reverse(int reverseSpeed, int reverseDuration) {
  moveMotor('c', "reverse", reverseDuration);
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
