/**
 * Runs a self test on the robot with verification.
 */
boolean selfTest() {
  Serial.println("EXEC: SelfTest.selfTest");
  
  // Run a Lipo voltage check before we start robot movement.
  if(isBatteryOK()) botReady = true;
  else return false; // Battery is dead
  
  // Drive system test.
  forward(MaxMotorSpeed, 500);
  reverse(MaxMotorSpeed, 500);
  spin(0, MaxMotorSpeed, 1000);
  spin(1, MaxMotorSpeed, 1000);
  
  // Ultrasonic Range Finder Tests.
  
  // Infared Tests
  
  
  return true;
}
