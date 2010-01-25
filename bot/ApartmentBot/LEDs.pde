/**
 * 
 */
void initLEDs(void) {
  Serial.println("EXEC: LED.Init_LEDs");
  pinMode(led_north, OUTPUT);  
  pinMode(led_east, OUTPUT);
  pinMode(led_south, OUTPUT);
  pinMode(led_west, OUTPUT);

  funLEDs(0, led_cycles, led_delay);
}


/**
 * Shutdown all the LEDs. 
 */
void offLEDs(void) {
  Serial.println("EXEC: LED.off_leds");
  digitalWrite(led_north,LOW);
  digitalWrite(led_east,LOW);
  digitalWrite(led_south,LOW);
  digitalWrite(led_west,LOW);
}


/**
 * A function to choose and change the behavior, you can add your custom patterns  
 */
void funLEDs(byte mode, byte cycles, unsigned int t_delay) {
  Serial.println("EXEC: LED.fun_LEDs");
  switch(mode) {
    case 0:
      // System to play with the leds
      for(int x = 0; x <= cycles; x++) {
        digitalWrite(led_north,LOW);
        digitalWrite(led_east,HIGH);
        delay(t_delay);
        
        digitalWrite(led_east,LOW);
        digitalWrite(led_south,HIGH);
        delay(t_delay);
        
        digitalWrite(led_south,LOW);
        digitalWrite(led_west,HIGH);
        delay(t_delay);
        
        digitalWrite(led_west,LOW);
        digitalWrite(led_north,HIGH);
        delay(t_delay);
      }
      digitalWrite(led_north,LOW);
    break; 
   
    case 1:
      // System to play with the leds
      for(int x=0; x<=cycles; x++) {
        digitalWrite(led_north,HIGH); // And I start blinking the LED like crazy..
        digitalWrite(led_east,HIGH);
        digitalWrite(led_south,HIGH);
        digitalWrite(led_west,HIGH);
        delay(t_delay);
        
        digitalWrite(led_north,LOW);
        digitalWrite(led_east,LOW);
        digitalWrite(led_south,LOW);
        digitalWrite(led_west,LOW);
        delay(t_delay);
      }
    break;
   
    case 2:
      //System to play with the leds
      for(int x=0; x<=cycles; x++) {
        digitalWrite(led_north,LOW);
        digitalWrite(led_south,LOW);
        digitalWrite(led_east,HIGH);
        digitalWrite(led_west,HIGH);
        delay(t_delay);
        
        digitalWrite(led_north,HIGH);
        digitalWrite(led_south,HIGH);
        digitalWrite(led_east,LOW);
        digitalWrite(led_west,LOW);
        delay(t_delay);
      }
      
      digitalWrite(led_east,LOW);
      digitalWrite(led_west,LOW);
      digitalWrite(led_north,LOW);
      digitalWrite(led_south,LOW);
    break;
  
    case 3:
      // This just blinks the north led...
      for(int x=0; x <= cycles; x++) {
        digitalWrite(led_north,HIGH);
        delay(t_delay);
        
        digitalWrite(led_north,LOW);
        delay(t_delay);
      }
    break;
  }
}
