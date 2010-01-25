#define sampleSize 8                  // MUST be a multiple of 2, see later for why
#define shiftBits 3                   // sampleSize = 2 ^ shiftBits

static int startVal = 512;            // I picked startVal somewhat arbitrariliy.  What you probably should do is read the sensor in setup(), do some calibrations by turning the sensor on and off with the reset pin (ST), and pick a good starting value.

int curSamp = 0;
int xVal = 0;
int yVal = 0;
int zVal = 0;
int xVals[sampleSize];
int yVals[sampleSize];
int zVals[sampleSize];
int xAvg = 0;
int yAvg = 0;
int zAvg = 0;
int xPreAvg = 0;
int yPreAvg = 0;
int zPreAvg = 0;


/**
 * Sets up the pinModes to the ADXLxx Accelerometer .
 */
void initADXL() {
  Serial.println("EXEC: ADXL3xx.initADXL");
  
  pinMode(ADXLxpin, INPUT);
  pinMode(ADXLypin, INPUT);
  pinMode(ADXLzpin, INPUT);

  for (int i=0; i < sampleSize; i++) {
    xVals[i] = startVal;
    xVals[i] = startVal;
    zVals[i] = startVal;
  }
}


/**
 * Monitors a ADXL3xx accelerometer and checks if the rover is close to tipping over.
 */ 
boolean monitorPitchAndRoll() {
  Serial.println("EXEC: ADXL3xx.monitorPitchAndRoll");
  
  // We use curSamp as an index into the array and increment at the
  // end of the main loop(), so see if we need to reset it at the
  // very start of the loop
  if (curSamp == sampleSize) curSamp = 0;

  xVal = analogRead(ADXLxpin);
  yVal = analogRead(ADXLypin);
  zVal = analogRead(ADXLzpin);

  xVals[curSamp] = xVal;
  yVals[curSamp] = yVal;
  zVals[curSamp] = zVal;
  
  xPreAvg = xAvg;
  yPreAvg = yAvg;
  zPreAvg = zAvg;
  
  xAvg = yAvg = zAvg = 0;
  //yAvg = 0;
  //zAvg = 0;
  
  for (int i=0; i < sampleSize; i++) {
	xAvg += xVals[i];
	yAvg += yVals[i];
	zAvg += zVals[i];
  }
  
  // For those who didn't grow up on C, "x >> y" is a way of saying
  // shift the bits in variable x y bits to the right, effectively
  // dividing by 2 and losing the remainder.  1 bit is in half, 2
  // bits is 1/4, and so on.  It's much faster than using the divide
  // operator "/" if you're working with powers of 2.  (Ok, so a
  // good compiler would optimize that for you, but this is just in
  // case.)
  xAvg = (xAvg >> shiftBits);
  yAvg = (yAvg >> shiftBits);
  zAvg = (zAvg >> shiftBits);
  
  Serial.print(xPreAvg);
  Serial.print(" ");
  Serial.print(xAvg);
  Serial.print(" ");
  Serial.print(xVal);
  Serial.print(" | ");
  Serial.print(yPreAvg);
  Serial.print(" ");
  Serial.print(yAvg);
  Serial.print(" ");
  Serial.print(yVal);
  Serial.print(" | ");
  Serial.print(zPreAvg);
  Serial.print(" ");
  Serial.print(zAvg);
  Serial.print(" ");
  Serial.println(zVal);

  curSamp++;  // increment our array pointer
  
  return true; // override (return false for tip);
  
  /*
  
  TODO: Add the conditions
  
  if(maxPitch) {
    
  }
  
  if(maxRoll) {
    
  }
  */
}
