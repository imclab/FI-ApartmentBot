/* For most of Firmata's life, it has run at 57600 b/s. This works well, but for certain applications, higher speed would be beneficial. Plus in other applications, other baud rates work better.
    * Bluetooth Arduino wants to communicate at 115200 b/s
    * The XBee radios want to communicate at 111111 b/s
    * The 16MHz clock naturally wants to communicate at 125000 b/s
    * Arduino can communicate to a DMX protocol 250000 b/s 
*/

#include <Firmata.h>

void setup() {
    Firmata.setFirmwareVersion(0, 2);
    Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
    Firmata.begin(57600);  // 57600 baud (default)
}

void loop() {
    while(Firmata.available()) Firmata.processInput();
}

void analogWriteCallback(byte pin, int value) {
    
}

