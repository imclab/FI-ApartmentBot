/* Testing the use of a voltage divider to analog pin 0 */
/*
  8.4V Lipo with 2x 10k resistors = 4.2V
  Reading on APin 0 (10bit) mean each value = 0.0048828125mV = 5V / 1024
  Thus battery voltage is = APinValue * 0.0048828125mV * 2
*/

const int voltageReadPin = 0;
const int voltageUnitValue = 0.0048828125;

void setup() {
  Serial.begin(9600);  
}


void loop() {
  int voltageVal = analogRead(voltageReadPin); 
  int batteryVoltage = voltageVal * voltageUnitValue * 2;
  Serial.println(batteryVoltage);
  delay(1000);
}
