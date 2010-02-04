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
  //Serial.println("Exec: UserControl.readIncommingCommand");
  
  /*
  do {
    while (!Serial.available()); // wait for input
    inputBuffer[inputLength] = Serial.read(); // read it in
  } while (inputBuffer[inputLength] != LineEnd && ++inputLength < BufferLength);
  */
  
  if(!Serial.available()) {
    int inputLength = 0;
    inputBuffer[inputLength] = Serial.read(); // read it in
    if(inputBuffer[inputLength] != LineEnd && ++inputLength < BufferLength) {
      inputBuffer[inputLength] = 0; //  add null terminator
      handelCommand(inputBuffer, inputLength);    
    }
  }
  
  //inputBuffer[inputLength] = 0; //  add null terminator
  //handelCommand(inputBuffer, inputLength);
}


/**
 * Handel the command.
 */
void handelCommand(char* input, int length) {
  //Serial.print("Exec: UserControl.handelCommand - ");
  //Serial.println(input);
  
  //if (length < 2) return; // Not a valid command
    
  int value = 0;
  
  if (length >= 2) {
    value = atoi(&input[1]);
  } else {
    value = MaxMotorSpeed;
  }
  
  int* command = (int*)input;
  
  // Call the proper method depending on command.
  switch(char(*command)) {
    case 'f': forward(value);   break; // Move forward
    case 'b': reverse(value);   break; // Move backwards
    case 'l': turnLeft(value);  break; // Spin left
    case 'r': turnRight(value); break; // Spin left
    case 's': stopRover();      break; // Stop
    
    default:
      Serial.println("Error: Invaild command.");
  }
}
