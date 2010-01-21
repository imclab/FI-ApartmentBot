package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import net.eriksjodin.arduino.Arduino;
	import net.eriksjodin.arduino.events.ArduinoEvent;
	
	
	
	public class RemoteRover extends Sprite {
		
		private var _socketServerIP:String = '127.0.0.1';
		private var _socketServerPort:int = 5331;
		private var _arduino:Arduino;
		
		
		/**
		 * Remote Rover Constructor
		 */
		public function RemoteRover() {
			trace('Exec: RemoteRover');
			
			buildUI();
			initKeyboardEvents();
			initSerialComm();
		}
		
		
		/**
		 * 
		 */
		private function buildUI():void {
			trace('Exec: RemoteRover.buildUI');
			generateTextAreas();
			initVideoStream();
		}
		
		
		/**
		 * Creates every text field needed for the application to display information.
		 */
		private function generateTextAreas():void {
			trace('Exec: RemoteRover.generateTextAreas');
			/* Top Left Read-Only Statistics */
			var statsTitle_txt:TextField; 
			
			
			
			/* Bottom Left Console */
			
			
			
			/* Bottom Right Controls */
			
		}
		
		
		/**
		 * Setup a serial connection to the Xbee connected to this system.
		 */
		private function initSerialComm():void {
			trace('Exec: RemoteRover.initSerialComm');
			_arduino = new Arduino(_socketServerIP, _socketServerPort);
			initArduinoEvents();
		}
		
		
		/**
		 * 
		 */
		private function initArduinoEvents():void {
			trace('Exec: RemoteRover.initArduinoEvents');
			_arduino.addEventListener(ArduinoEvent.DIGITAL_DATA, onReceiveDigitalData, false, 0, true); 
			_arduino.addEventListener(ArduinoEvent.ANALOG_DATA, onReceiveAnalogData, false, 0, true); 
		}
		
		
		/**
		 * An event listener that is called whenever a digital input changes.
		 * 
		 * @param	e
		 */
		private function onReceiveDigitalData(e:ArduinoEvent):void {
			trace('Evt: RemoteRover.onReceiveDigitalData');
			trace("Digital pin " + e.pin + " on port: " + e.port + " = " + e.value); 
		}
		
		
		/**
		 * An event listener that is called whenever a analog input changes.
		 * 
		 * @param	e
		 */
		public function onReceiveAnalogData(e:ArduinoEvent):void {
			trace('Evt: RemoteRover.onReceiveAnalogData');
			trace("Analog pin " + e.pin + " on port: " + e.port +" = " + e.value); 
		} 
		
		
		/**
		 * 
		 */
		private function initVideoStream():void {
			trace('Exec: RemoteRover.initVideoStream');
			var videoBackground:Sprite = new Sprite();
			videoBackground.graphics.beginFill(0x000000);
			videoBackground.graphics.drawRect(0, 0, 640, 480);
			videoBackground.graphics.endFill();
			videoBackground.x = stage.stageWidth - videoBackground.width - 10;
			videoBackground.y = 10;
			addChild(videoBackground);
			
		}
		
		
		private function initKeyboardEvents():void {
			trace('Exec: RemoteRover.initKeyboardEvents');
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
		}
		
		
		/**
		 * 
		 * @param	e
		 */
		private function keyDown(e:KeyboardEvent):void {
			trace('Evt: RemoteRover.keyDown');
			
			switch(e.keyCode) {
				case 37:
				case 38:
				case 39:
				case 40:
					trace('Arrow Keys');
				break;
			}
		}
		
		
		/**
		 * 
		 * @param	e
		 */
		private function keyUp(e:KeyboardEvent):void {
			trace('Evt: RemoteRover.keyUp');
		}
		
	}
	
}