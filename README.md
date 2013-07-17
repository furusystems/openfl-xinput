openfl-xinput
=============

XInput/Xbox 360 controller support for OpenFL on Windows

So far, done in a hurry, but works. Usage:
	
```
controller = new XBox360Controller(0); //create a new controller with a unique controller ID (zero indexed)
controller.isConnected(); //Check if the controller is connected. Returns a boolean.
//set stick deadzones with a scalar. You can also set the deadzone precisely with an int within 32767
controller.leftStick.deadZoneNorm = 0.2; 
controller.rightStick.deadZoneNorm = 0.2;

//during game updates..
controller.poll(); //first poll to update the controller state. The returned state is natively updated at 20hz so frequency here is not a must.

//Poll controller.state for buttons.
//Buttons are booleans, triggers are ints between 0 and 255, sticks are slightly more involved
controller.state.leftStick.xRaw; //The raw -32767 to 32767 range
controller.state.leftStick.xNorm; //The range normalized to a bipolar 0-1 scalar, pre-adjusted by the deadzone

//The 360 controller has two vibrators. In my experience the left vibrator is "coarser" while the right vibrator is "finer". 
if (controller.state.leftBumper) {
	controller.vibrationLeftNorm = controller.state.leftTriggerNorm;
}else {
	controller.vibrationLeft = 0; //Vibrations remain set so you have to manually turn them off
}
if (controller.state.rightBumper) {
	controller.vibrationRightNorm = controller.state.rightTriggerNorm;
}else {
	controller.vibrationRight = 0; 
}
//The vibrators have quite a nice dynamic range; You can fine control it up to 65535. 
//I've seen games use this to "drive" the vibrators with audio signals. Quite cool.
```