/**
 * Runs a self test on the robot with verification.
 */
boolean selfTest() {
  Serial.println("");
  Serial.println("EXEC: SelfTest.selfTest - Starting Self Test");
  
  // Run a Lipo voltage check before we start robot movement.
  if(isBatteryOK()) botReady = true;
  else {
    Serial.println("Warning: Battery check has failed self test.");
    return false; // Battery is dead
  }
  
  // Drive system test.
  forward(MaxMotorSpeed, 500);
  reverse(MaxMotorSpeed, 500);
  spin(0, MaxMotorSpeed, 1000);
  spin(1, MaxMotorSpeed, 1000);
  
  // Ultrasonic Range Finder Tests.
  
  // Infared Tests
  
  Serial.println("EXEC: SelfTest.selfTest - Finished Self Test");
  Serial.println("");
  
  return true;
}
