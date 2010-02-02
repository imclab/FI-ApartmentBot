/* Testing the use of a voltage divider to analog pin 0 */
/*
  8.4V Lipo with 2x 10k resistors = 4.2V
  Reading on APin 0 (10bit) mean each value = 0.0048828125mV = 5V / 1024
  Thus battery voltage is = APinValue * 0.0048828125mV * 2
*/

const int voltageReadPin = 0;
const int voltageUnitValue = 0.0048828125;
const int alertVoltage = 5;                  // The voltage we will alert of low voltage.
const int minimumVoltage = 5;                // The minumum voltage we will allow the robot to get to (to save the Lipos).
int currentBatteryVoltage = 0;               // Global value to hold the last read voltage.


/**
 * Returns a boolean value on the voltage state of the battery. (ie. a quick check conditioned against pre-defined values)
 */
boolean isBatteryOK() {
  Serial.println("EXEC: Voltage.isBatteryOK");
  currentBatteryVoltage = readVoltage();
  
  // Debug bypass
  if(currentBatteryVoltage == 0) {
    Serial.println("Warning: No battery found.");
    return true; // If the voltage is 0 there is no battery and we are connected to USB or the wall.
  }
  
  if(currentBatteryVoltage <= alertVoltage || currentBatteryVoltage <= minimumVoltage) return false;
  else return true;
}


/**
 * Reads the input from analog 0 from the voltage divider and converts its into the actual voltage.
 */
int readVoltage() {
  int voltageVal = analogRead(voltageReadPin); 
  int batteryVoltage = voltageVal * voltageUnitValue * 2;
  
  Serial.print("EXEC: Voltage.readVoltage - ");
  Serial.print(batteryVoltage);
  Serial.println("V");
  
  return batteryVoltage;
}

