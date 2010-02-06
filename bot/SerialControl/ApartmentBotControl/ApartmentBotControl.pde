import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

void setup() {
  size(210, 420);
  
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(255);
  
  // move forward
  switch(mouseOverRect()) {  
    //case 1:
    //  fill(204);            
    //  myPort.write("FF200#");
    //break;
    
    case 2:
      myPort.write("f100#");
    break;
    
    case 3:
      myPort.write("b100#");
    break;
    
    case 4:
      myPort.write("l100#");
    break;
    
    case 5:
      myPort.write("r100#");
    break;
    
    default:
      myPort.write("s#");
  }
 
  
  rect(10, 10, 190, 90); // forward
  
  rect(10, 110, 90, 80); // left f 
  rect(110, 110, 90, 80); // right f
  
  rect(10, 200, 90, 80); // left f 
  rect(110, 200, 90, 80); // right f
  
  rect(10, 290, 190, 90); // reverse
}

int mouseOverRect() { // Test if mouse is over square
  if((mouseX >= 10) && (mouseX <= 200) && (mouseY >= 10) && (mouseY <= 100)) {
    return 1;  
  }
  
  // left f
  if((mouseX >= 10) && (mouseX <= 100) && (mouseY >= 110) && (mouseY <= 190)) {
    return 2;  
  }
  
  // right f
  if((mouseX >= 110) && (mouseX <= 200) && (mouseY >= 110) && (mouseY <= 190)) {
    return 3;  
  }
  
  
  // left r
  if((mouseX >= 10) && (mouseX <= 100) && (mouseY >= 200) && (mouseY <= 280)) {
    return 4;  
  }
  
  // right r
  if((mouseX >= 110) && (mouseX <= 200) && (mouseY >= 200) && (mouseY <= 280)) {
    return 5;  
  }
  
  return 0;
}

