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
  forward(120, 200);
  delay(500);
  reverse(120, 200);
  delay(500);
  spin(0, 100, 500);
  delay(500);
  spin(1, 100, 500);
  delay(500);
  
  Serial.println("EXEC: SelfTest.selfTest - Finished Self Test");
  Serial.println("");
  
  return true;
}
