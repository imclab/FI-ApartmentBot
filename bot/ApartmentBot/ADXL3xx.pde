const int xPin = 1;   // x-axis of the accelerometer output - analog pin
const int yPin = 2;   // y-axis of the accelerometer output - analog pin
const int zPin = 3;   // z-axis of the accelerometer output - analog pin

const int zeroOffsetSamples = 1000;  // # of samples to average for zero offset
const int calibrateSeconds = 10;     // number of seconds for calibration test


long xZero = 0;  // zero offset value for each axis (values at rest)
long yZero = 0;
long zZero = 0;

int xMin = 0;  // min and max values found on each axis during calibration
int xMax = 0;
int yMin = 0;
int yMax = 0;
int zMin = 0;
int zMax = 0;

int x, y, z;  // for reading pin values

long startCalibration;  // timer start value for calibration



/**
 * Sets up the pinModes to the ADXLxx Accelerometer .
 */
void initADXL() {
  Serial.println("EXEC: ADXL3xx.initADXL");
  
  zeroOut();
}

/**
 * Establish the zero offset values for each axis by reading the pin values a bunch of 
 * times and averaging them -- the board must be motionless during this loop.
 */
void zeroOut() {
  for (int i=0; i<zeroOffsetSamples; i++) {
    xZero += analogRead (xPin);
    yZero += analogRead (yPin);
    zZero += analogRead (zPin);
  }

  xZero /= zeroOffsetSamples;
  yZero /= zeroOffsetSamples;
  zZero /= zeroOffsetSamples;

  Serial.println("*** Zero offset:");
  Serial.print("x: "); 
  Serial.println(xZero);
  Serial.print("y: "); 
  Serial.println(yZero);
  Serial.print("z: "); 
  Serial.println(zZero);

  xMin = xZero;
  xMax = xZero;
  yMin = yZero;
  yMax = yZero;
  zMin = zZero;
  zMax = zZero;
  
  // Watch for the max and min values on each
  // axis and save them (will be used in real app)
  // if the board is rotated +/- 90 degrees, we can auto-calibrate
  startCalibration = millis ();

  while ((millis () - startCalibration) < long (calibrateSeconds * 1000)) {
    x = analogRead (xPin);
    y = analogRead (yPin);
    z = analogRead (zPin);
    xMin = min (xMin, x);  //  - xZero);
    xMax = max (xMax, x);  //  - xZero);
    yMin = min (yMin, y);  //  - yZero);
    yMax = max (yMax, y);  //  - yZero);
    zMin = min (zMin, z);  //  - zZero);
    zMax = max (zMax, z);  //  - zZero);
  } 

  
  Serial.println ("*** Minimax: ");
  Serial.print   ("x raw : "); Serial.print (xMin); Serial.print ("\t"); Serial.println (xMax);
  Serial.print   ("y raw : "); Serial.print (yMin); Serial.print ("\t"); Serial.println (yMax);
  Serial.print   ("z raw : "); Serial.print (zMin); Serial.print ("\t"); Serial.println (zMax);
  Serial.print   ("x zero: "); Serial.print (xMin - xZero); Serial.print ("\t"); Serial.println (xMax - xZero);
  Serial.print   ("y zero: "); Serial.print (yMin - yZero); Serial.print ("\t"); Serial.println (yMax - yZero);
  Serial.print   ("z zero: "); Serial.print (zMin - zZero); Serial.print ("\t"); Serial.println (zMax - zZero);
}


/**
 * Monitors a ADXL3xx accelerometer and checks if the rover is close to tipping over.
 */ 
void monitorPitchAndRoll() {
  //Serial.println("EXEC: ADXL3xx.monitorPitchAndRoll");
}

  

