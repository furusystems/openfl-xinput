package com.furusystems.openfl.input.xinput;
import flash.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */
class Xbox360ControllerState
{
	public static inline var TRIGGER_MAX_MAG:Int = 255;
	public var triggerDeadzone:Int;
	private var rawData:Array<Dynamic>;
	
	public var up:Bool;
	public var down:Bool;
	public var left:Bool;
	public var right:Bool;
	public var start:Bool;
	public var back:Bool;
	public var leftThumbButton:Bool;
	public var rightThumbButton:Bool;
	public var leftBumper:Bool;
	public var rightBumper:Bool;
	public var a:Bool;
	public var b:Bool;
	public var x:Bool;
	public var y:Bool;
	
	public var leftStick:XBox360ThumbStick;
	public var rightStick:XBox360ThumbStick;
	public var leftTrigger:Int;
	public var leftTriggerNorm:Float;
	public var rightTrigger:Int;
	public var rightTriggerNorm:Float;
	
	public function new() 
	{
		leftStick = new XBox360ThumbStick();
		rightStick = new XBox360ThumbStick();
		rightTrigger = leftTrigger = 0;
		triggerDeadzone = 0;
	}
	public inline function update(data:Array<Dynamic>) {
		rawData = data;
		up = rawData[0] != 0;
		down = rawData[1] != 0;
		left = rawData[2] != 0;
		right = rawData[3] != 0;
		start = rawData[4] != 0;
		back = rawData[5] != 0;
		leftThumbButton = rawData[6] != 0;
		rightThumbButton = rawData[7] != 0;
		leftBumper = rawData[8] != 0;
		rightBumper = rawData[9] != 0;
		a = rawData[10] != 0;
		b = rawData[11] != 0;
		x = rawData[12] != 0;
		y = rawData[13] != 0;
		if (rawData[14] < triggerDeadzone) rawData[14] = 0;
		if (rawData[15] < triggerDeadzone) rawData[15] = 0;
		leftTriggerNorm = (leftTrigger = rawData[14] - triggerDeadzone) / (TRIGGER_MAX_MAG - triggerDeadzone);
		rightTriggerNorm = (rightTrigger = rawData[15] - triggerDeadzone) / (TRIGGER_MAX_MAG - triggerDeadzone);
		leftStick.updateWith(rawData[16], rawData[17]);
		rightStick.updateWith(rawData[18], rawData[19]);
	}
	
	
	
}