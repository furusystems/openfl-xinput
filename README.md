openfl-xinput
=============

XInput/Xbox 360 controller support for OpenFL on Windows

So far, done in a hurry, but works. Usage:

##Initialization
Create a new controller with a unique controller ID (zero indexed)
You should also check if it's connected. 
```ActionScript
controller = new XBox360Controller(0);
controller.isConnected();
```

##Deadzones
Set individual stick deadzones with a scalar. You can also set the deadzone precisely with an int within 32767
```ActionScript
controller.leftStick.deadZoneNorm = 0.2; 
controller.rightStick.deadZoneNorm = 0.2;
```
Both triggers share the same deadzone setting, an int from 0 to 255
```ActionScript
controller.state.triggerDeadzone = 30;
```

##Game update
During game updates, call poll() to update the controller state. The returned state is natively updated at 20hz so frequency here is not a must. 
```ActionScript
controller.poll();
```

Poll controller.state for buttons.
Buttons are booleans, triggers are ints between 0 and 255, sticks are slightly more involved
```ActionScript
controller.state.leftStick.xRaw; //The raw -32767 to 32767 range
controller.state.leftStick.xNorm; //The range normalized to a bipolar 0-1 scalar, pre-adjusted by the deadzone
```

##Rumble
The 360 controller has two vibrators. In my experience the left vibrator is "coarser" while the right vibrator is "finer". 
```ActionScript
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
```
The vibrators have quite a nice dynamic range; You can fine control it up to 65535. 
I've seen games use this to "drive" the vibrators with audio signals. Quite cool.