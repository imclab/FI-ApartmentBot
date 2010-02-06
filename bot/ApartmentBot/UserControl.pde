/**
 * User Command List
 * -----------------
 * Directions - f = forward
 *              b = backwards
 *              l = left spin
 *              r = right spin
 *              
 * Power - 1 - 255
 *
 *
 * Example Command: "f200#"
 */

const int BufferLength = 16;
const char LineEnd = '#';    // Character to end a line

char inputBuffer[BufferLength];


/**
 * Watches for incomming serial commands from the host.
 */
void readIncommingCommand() {
  Serial.println("Notice: Robot ready for command...");
  
  int inputLength = 0;
  do {
    while (!Serial.available()); // wait for input
    inputBuffer[inputLength] = Serial.read(); // read it in
  } while (inputBuffer[inputLength] != LineEnd && ++inputLength < BufferLength);
  
  inputBuffer[inputLength] = 0; //  add null terminator
  handelCommand(inputBuffer, inputLength);
}


/**
 * Handel the command.
 */
void handelCommand(char* input, int length) {
  //Serial.print("Exec: UserControl.handelCommand - ");
  
  int value = MaxMotorSpeed;
  
  if (length >= 2) value = atoi(&input[1]);
  
  int* command = (int*)input;
  
  // Call the proper method depending on command.
  switch(char(*command)) {
    case 'f': 
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPinMotorA, HIGH);
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPinMotorB, LOW); 
    break; 
    
    case 'b': 
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPinMotorA, LOW);
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPinMotorB, HIGH);  
    break; 
    
    case 'l': 
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPinMotorA, HIGH);
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPinMotorB, HIGH);
    break; 
    
    case 'r': 
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPinMotorA, LOW);
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPinMotorB, LOW);
    break; 
    
    case 's': 
      analogWrite(PwmPinMotorA, 0);
      digitalWrite(DirectionPinMotorA, LOW);
      analogWrite(PwmPinMotorB, 0);
      digitalWrite(DirectionPinMotorB, LOW);     
    break; 
    
    default: Serial.println("Error: Invaild command.");
  }
}
