/**
 * Starts moving the robot autonomously.
 */
void rove(int checkDelay) {
  Serial.println("EXEC: Rover.rove");

  // Make sure we aren't going to tip over. (ADXLxx)
  //if(monitorPitchAndRoll()) {
    // Start by checking if anything is infront of us (minimumDetectDistance)
    int dis = readPing();
    
    /*if(dis == 0) Serial.println("Error: Ultrasonic range sensor reads 0.");
    else {
      if(dis < minimumDetectDistance) {
        stopRover();                     // Stop the rover before hitting the object.
        reverse(MaxMotorSpeed / 2, 750); // Reverse for 3/4 of a second to allow for swing on the turn. 
        
        // Select a random direction to turn
        obsticalCheck(random(0, 2));
        
      } else*/ moveMotor('c', "forward", MaxMotorSpeed); // Move forward.
      
      delay(checkDelay);
   // }
  //} else {
    // About to tip over, stop and correct.
   // Serial.println("Warning: Tip correction activated.");
    
   // stopRover();
    
    // TODO: Calculate which way to turn around based on roll.  
  //}
  
  Serial.println("");
}


/**
 * Runs a obstical check by checking every couple degrees
 */
void obsticalCheck(int turnDirection) {
  Serial.println("EXEC: Rover.obsticalCheck");
  
  boolean spinRequired = true;
    
  for(int x = 0; x < suprtCheckAmount; x++) {
    spin(turnDirection, MaxMotorSpeed * 0.5, spurtDuration); // Small burst (spurt) of movement (be sure there is enough power but not too much)
    
    if(readPing() > minimumDetectDistance) {
      spinRequired = false;
      break;  // Check the distance again, break if we are clear.
    }
  }
  
  // If we don't get a clear path in our checks bailout and do a 180.
  if(spinRequired) {
    // Spin back to inital position
    //int revDir = 0;
    //if(turnDirection == 1) revDir = 1; // This can be cleaned up.
    //spin(revDir, MaxMotorSpeed * 0.5, spurtDuration * x);
    
    spin(turnDirection, MaxMotorSpeed * 0.8, SpinDuration); // Spin 180
  }
}
