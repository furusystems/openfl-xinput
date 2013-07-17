package com.furusystems.openfl.input.xinput;
import flash.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */
class XBox360ThumbStick
{
	public static inline var STICK_MAX_MAG:Int = 32767;
	
	public var rawX:Float;
	public var rawY:Float;
	public var xNorm:Float;
	public var yNorm:Float;
	
	private var _deadZone:Float = 0;
	public function new() 
	{
		rawX = rawY = xNorm = yNorm = 0;
	}
	public inline function updateWith(x:Float, y:Float):Void {
		rawX = x;
		rawY = y;
		var mag:Float = getMagnitude();
		var magRaw:Float = mag;
		if (mag < deadZone) {
			rawX = rawY = xNorm = yNorm = 0;
		}else {
			if (mag > STICK_MAX_MAG) mag = STICK_MAX_MAG;
			mag -= deadZone;
			var normalizedMagnitude = mag / (STICK_MAX_MAG - deadZone);
			xNorm = (rawX / magRaw) * normalizedMagnitude;
			yNorm = (rawY / magRaw) * normalizedMagnitude;
		}
	}
	public inline function getMagnitudeSqr():Float {
		return rawX * rawX + rawY * rawY;
	}
	public inline function getMagnitude():Float {
		return Math.sqrt(getMagnitudeSqr());
	}
	public inline function normalizeEq():Void {
		var mag:Float = getMagnitude();
		rawX = rawX / mag;
		rawY = rawY / mag;
	}
	public inline function normalizeToPt():Point {
		var mag:Float = getMagnitude();
		return new Point(rawX / mag, rawY/mag);
	}
	public inline function toPt():Point {
		return new Point(rawX, rawY);
	}
	public inline function copyToPt(pt:Point):Void {
		pt.setTo(rawX, rawY);
	}
	public inline function getAngleRad():Float {
		return Math.atan2(rawY, rawX);
	}
	
	function get_deadZone():Float 
	{
		return _deadZone;
	}
	
	function set_deadZone(value:Float):Float 
	{
		return _deadZone = value;
	}
	
	function get_deadZoneNorm():Float 
	{
		return _deadZone/STICK_MAX_MAG;
	}
	
	function set_deadZoneNorm(value:Float):Float 
	{
		return _deadZone = value*STICK_MAX_MAG;
	}
	
	public var deadZone(get_deadZone, set_deadZone):Float;
	public var deadZoneNorm(get_deadZoneNorm, set_deadZoneNorm):Float;
	
}