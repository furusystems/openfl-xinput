package com.furusystems.openfl.input.xinput;

/**
 * ...
 * @author Andreas Rønning
 */

class Xbox360Button
{
	public var isDown:Bool;
	public var buttonType:Xbox360ButtonType;
	public var controller:XBox360Controller;
	public function new(controller:XBox360Controller, buttonType:Xbox360ButtonType) 
	{
		this.controller = controller;
		this.buttonType = buttonType;
		isDown = false;
	}
	public var onPressed:Xbox360Button->Void;
	public var onReleased:Xbox360Button->Void;
	
}