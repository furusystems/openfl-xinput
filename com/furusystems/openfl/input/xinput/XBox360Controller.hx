package com.furusystems.openfl.input.xinput;
import cpp.Lib;

/**
 * ...
 * @author Andreas Rønning
 */

 
class XBox360Controller
{
	public static inline var MAX_VIBRATION_STRENGTH:Int = 65535;
	public static inline var TRIGGER_MAX_MAG:Int = 255;
	private var _id:Int;
	
	private var _vibrationLeft:Int;
	private var _vibrationRight:Int;
	
	
	public var triggerDeadzone:Int;
	private var rawData:Array<Dynamic>;
	
	public var up:Xbox360Button;
	public var down:Xbox360Button;
	public var left:Xbox360Button;
	public var right:Xbox360Button;
	public var start:Xbox360Button;
	public var back:Xbox360Button;
	public var leftThumbButton:Xbox360Button;
	public var rightThumbButton:Xbox360Button;
	public var leftBumper:Xbox360Button;
	public var rightBumper:Xbox360Button;
	public var a:Xbox360Button;
	public var b:Xbox360Button;
	public var x:Xbox360Button;
	public var y:Xbox360Button;
	
	public var leftStick:XBox360ThumbStick;
	public var rightStick:XBox360ThumbStick;
	public var leftTrigger:Int;
	public var leftTriggerNorm:Float;
	public var rightTrigger:Int;
	public var rightTriggerNorm:Float;
	
	public function new(id:Int) 
	{
		_id = id;
		
		up = new Xbox360Button(this, Xbox360ButtonType.DpadUP);
		down = new Xbox360Button(this, Xbox360ButtonType.DpadDOWN);
		left = new Xbox360Button(this, Xbox360ButtonType.DpadLEFT);
		right = new Xbox360Button(this, Xbox360ButtonType.DpadRIGHT);
		start = new Xbox360Button(this, Xbox360ButtonType.Start);
		back = new Xbox360Button(this, Xbox360ButtonType.Back);
		leftThumbButton = new Xbox360Button(this, Xbox360ButtonType.LeftStick);
		rightThumbButton = new Xbox360Button(this, Xbox360ButtonType.RightStick);
		leftBumper = new Xbox360Button(this, Xbox360ButtonType.LeftBumper);
		rightBumper = new Xbox360Button(this, Xbox360ButtonType.RightBumper);
		a = new Xbox360Button(this, Xbox360ButtonType.A);
		b = new Xbox360Button(this, Xbox360ButtonType.B);
		x = new Xbox360Button(this, Xbox360ButtonType.X);
		y = new Xbox360Button(this, Xbox360ButtonType.Y);
		
		leftStick = new XBox360ThumbStick();
		rightStick = new XBox360ThumbStick();
		rightTrigger = leftTrigger = 0;
		triggerDeadzone = 0;
	}
	
	public inline function clearButtonListeners():Void {
		setButtonListeners();
	}
	public inline function setButtonListeners(?onPressed:Xbox360Button->Void, ?onReleased:Xbox360Button->Void):Void {
		up.onPressed = onPressed;
		up.onReleased = onReleased;
		down.onPressed = onPressed;
		down.onReleased = onReleased;
		left.onPressed = onPressed;
		left.onReleased = onReleased;
		right.onPressed = onPressed;
		right.onReleased = onReleased;
		a.onPressed = onPressed;
		a.onReleased = onReleased;
		b.onPressed = onPressed;
		b.onReleased = onReleased;
		x.onPressed = onPressed;
		x.onReleased = onReleased;
		y.onPressed = onPressed;
		y.onReleased = onReleased;
		leftBumper.onPressed = onPressed;
		leftBumper.onReleased = onReleased;
		rightBumper.onPressed = onPressed;
		rightBumper.onReleased = onReleased;
		leftThumbButton.onPressed = onPressed;
		leftThumbButton.onReleased = onReleased;
		rightThumbButton.onPressed = onPressed;
		rightThumbButton.onReleased = onReleased;
		start.onPressed = onPressed;
		start.onReleased = onReleased;
		back.onPressed = onPressed;
		back.onReleased = onReleased;
	}
	
	public static function isControllerConnected(id:Int):Bool {
		return xinput_isconnected(id);
	}
	
	public inline function setVibration(leftStrength:Int, rightStrength:Int) {
		xinput_vibrate(_id, leftStrength, rightStrength);
	}
	
	public function isConnected():Bool {
		return xinput_isconnected(_id);
	}
	
	public function poll():Void {
		updateState(xinput_poll(_id));
	}
	
	private inline function setButtonState(button:Xbox360Button, state:Bool):Void {
		var currentState:Bool = button.isDown;
		if (currentState != state) {
			button.isDown = state;
			if (state) {
				if (button.onPressed != null) button.onPressed(button);
			}else {
				if (button.onReleased != null) button.onReleased(button);
			}
		}
	}
	
	private inline function updateState(data:Array<Dynamic>) {
		setButtonState(up, data[0] != 0);
		setButtonState(down, data[1] != 0);
		setButtonState(left, data[2] != 0);
		setButtonState(right, data[3] != 0);
		setButtonState(start, data[4] != 0);
		setButtonState(back, data[5] != 0);
		setButtonState(leftThumbButton, data[6] != 0);
		setButtonState(rightThumbButton, data[7] != 0);
		setButtonState(leftBumper, data[8] != 0);
		setButtonState(rightBumper, data[9] != 0);
		setButtonState(a, data[10] != 0);
		setButtonState(b, data[11] != 0);
		setButtonState(x, data[12] != 0);
		setButtonState(y, data[13] != 0);
		
		if (data[14] < triggerDeadzone) {
			leftTriggerNorm = 0;
			leftTrigger = 0;
		}else {
			leftTriggerNorm = (leftTrigger = (Std.int(data[14]) - triggerDeadzone)) / (TRIGGER_MAX_MAG - triggerDeadzone);
		}
		if (data[15] < triggerDeadzone) {
			rightTriggerNorm = 0;
			rightTrigger = 0;
		}else {
			rightTriggerNorm = (rightTrigger = (Std.int(data[15]) - triggerDeadzone)) / (TRIGGER_MAX_MAG - triggerDeadzone);
		}
		leftStick.updateWith(data[16], data[17]);
		rightStick.updateWith(data[18], data[19]);
		
		rawData = data;
	}
	
	function get_id():Int 
	{
		return _id;
	}
	
	public var id(get_id, null):Int;
	
	function get_vibrationLeft():Int 
	{
		return _vibrationLeft;
	}
	
	function set_vibrationLeft(value:Int):Int 
	{
		_vibrationLeft = value;
		setVibration(_vibrationLeft, _vibrationRight);
		return _vibrationLeft;
	}
	
	function get_vibrationLeftNorm():Float 
	{
		return _vibrationLeft / MAX_VIBRATION_STRENGTH;
	}
	
	function set_vibrationLeftNorm(value:Float):Float 
	{
		_vibrationLeft = Std.int(value * MAX_VIBRATION_STRENGTH);
		setVibration(_vibrationLeft, _vibrationRight);
		return _vibrationRight;
	}
	
	public var vibrationLeft(get_vibrationLeft, set_vibrationLeft):Int;
	public var vibrationLeftNorm(get_vibrationLeftNorm, set_vibrationLeftNorm):Float;
	
	function get_vibrationRight():Int 
	{
		return _vibrationRight;
	}
	
	function set_vibrationRight(value:Int):Int 
	{
		_vibrationRight = value;
		setVibration(_vibrationLeft, _vibrationRight);
		return _vibrationRight;
	}
	
	function get_vibrationRightNorm():Float 
	{
		return _vibrationRight / MAX_VIBRATION_STRENGTH;
	}
	
	function set_vibrationRightNorm(value:Float):Float 
	{
		_vibrationRight = Std.int(value * MAX_VIBRATION_STRENGTH);
		setVibration(_vibrationLeft, _vibrationRight);
		return _vibrationRight;
	}
	
	public var vibrationRight(get_vibrationRight, set_vibrationRight):Int;
	public var vibrationRightNorm(get_vibrationRightNorm, set_vibrationRightNorm):Float;
	
	static var xinput_vibrate = Lib.load("xinput", "vibrate", 3);
	static var xinput_poll = Lib.load("xinput", "poll", 1);
	static var xinput_isconnected = Lib.load("xinput", "isConnected", 1);
	
}