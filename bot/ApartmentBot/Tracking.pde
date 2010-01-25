/**
 * Attempts to calculate where the robot has been.
 */
void trackProgress() {
  Serial.println("EXEC: Tracking.trackProgress");

  // TODO: figure out how to calculate this.
}


/**
 * Attempts to find the docking station to recharge the power system.
 * The station holds a infared LED array which we will attempt to locate, confirm and approach.
 *
 * Pololu IR Beacon Transceiver Pair
 */
void findHome() {
  Serial.println("EXEC: Tracking.findHome");
  readIRs();        // Capture IR packets..
  analyseIRs(500);  // After 500 millisecon will analyse the packets captured
}
