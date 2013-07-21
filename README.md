openfl-xinput
=============

XInput/Xbox 360 controller support for OpenFL on Windows.
For the Windows target, given that the user has a 360 controller, here are the key benefits over the OpenFL JoystickEvent:
* Individual data for each trigger. Under DirectInput/JoystickEvent you get both triggers as a single bipolar axis (useless)
* Individual control over each vibrator. Allows for a wide range of haptic feedback.
* Controller hotswapping. Your game will happily run with or without a controller connected. A controller may get dropped and reconnected to no further detriment to your game.
* Simplified API. The XBox360Controller class is a one-stop, direct way to get at the game controller.

Usage:

##Initialization
Create a new controller with a unique controller ID (zero indexed)
You should also check if it's connected. 
```ActionScript
controller = new XBox360Controller(0);
controller.isConnected();
```
You can check if the controller is connected without creating an instance
```ActionScript
XBox360Controller.isControllerConnected(0);
```

##Deadzones
Set individual stick deadzones with a scalar. You can also set the deadzone precisely with an int within 32767
```ActionScript
controller.leftStick.deadZoneNorm = 0.2; 
controller.rightStick.deadZoneNorm = 0.2;
```
Both triggers share the same deadzone setting, an int from 0 to 255
```ActionScript
controller.triggerDeadzone = 30;
```

##Game update
During game updates, call poll() to update the controller state. 
```ActionScript
controller.poll();
```

Poll controller for buttons and values.
Buttons are booleans, triggers are ints between 0 and 255, sticks are slightly more involved
```ActionScript
controller.leftStick.xRaw; //The raw -32767 to 32767 range
controller.leftStick.xNorm; //The range normalized to a bipolar 0-1 scalar, pre-adjusted by the deadzone
```

##Rumble
The 360 controller has two vibrators. In my experience the left vibrator is "coarser" while the right vibrator is "finer". 
```ActionScript
if (controller.leftBumper.isDown) {
	controller.vibrationLeftNorm = controller.leftTriggerNorm;
}else {
	controller.vibrationLeft = 0; //Vibrations remain set so you have to manually turn them off
}
if (controller.rightBumper.isDown) {
	controller.vibrationRightNorm = controller.rightTriggerNorm;
}else {
	controller.vibrationRight = 0; 
}
```
The vibrators have quite a nice dynamic range; You can fine control it up to 65535. 
I've seen games use this to "drive" the vibrators with audio signals. Quite cool.

##Events
XBox360Controller buttons are represented with Xbox360Button objects. To receive callbacks when a button is pressed or released, do the following:
```ActionScript
function onButtonChange(btn:Xbox360Button):Void 
{
	trace(btn.buttonType, btn.controller.id, btn.isDown);
}

controller.a.onPressed = onButtonChange;
controller.a.onReleased = onButtonChange;
```
Xbox360Button.buttonType is one of the types found in Xbox360ButtonType.

For convenience, Xbox360Controller has a method for setting listeners on every button.

```ActionScript
controller.setButtonListeners(onButtonDown, onButtonUp);
//to clear the listeners, call again with no arguments, or use clearButtonListeners()
```