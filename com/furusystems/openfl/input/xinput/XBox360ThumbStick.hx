package com.furusystems.openfl.input.xinput;
import flash.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */
class XBox360ThumbStick
{
	public static inline var STICK_MAX_MAG:Int = 32767;
	
	public var xRaw:Float;
	public var yRaw:Float;
	public var xNorm:Float;
	public var yNorm:Float;
	
	private var _deadZone:Float = 0;
	public function new() 
	{
		xRaw = yRaw = xNorm = yNorm = 0;
	}
	public inline function updateWith(x:Float, y:Float):Void {
		xRaw = x;
		yRaw = y;
		var mag:Float = getMagnitude();
		var magRaw:Float = mag;
		if (mag < deadZone) {
			xRaw = yRaw = xNorm = yNorm = 0;
		}else {
			if (mag > STICK_MAX_MAG) mag = STICK_MAX_MAG;
			mag -= deadZone;
			var normalizedMagnitude = mag / (STICK_MAX_MAG - deadZone);
			xNorm = (xRaw / magRaw) * normalizedMagnitude;
			yNorm = (yRaw / magRaw) * normalizedMagnitude;
		}
	}
	public inline function getMagnitudeSqr():Float {
		return xRaw * xRaw + yRaw * yRaw;
	}
	public inline function getMagnitude():Float {
		return Math.sqrt(getMagnitudeSqr());
	}
	public inline function normalizeEq():Void {
		var mag:Float = getMagnitude();
		xRaw = xRaw / mag;
		yRaw = yRaw / mag;
	}
	public inline function normalizeToPt():Point {
		var mag:Float = getMagnitude();
		return new Point(xRaw / mag, yRaw/mag);
	}
	public inline function toPt():Point {
		return new Point(xRaw, yRaw);
	}
	public inline function copyToPt(pt:Point):Void {
		#if flash11
        pt.setTo(xRaw, yRaw);
        #else
        pt.x = xRaw;
        pt.y = yRaw;
        #end
	}
	public inline function getAngleRad():Float {
		return Math.atan2(yRaw, xRaw);
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