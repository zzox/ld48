package display;

/*
@author:  Pennie Quinn
@created: Mar 13, 2018

	A simple "cutout" lighting system. Works the same on html5, flash, and cpp
	targets (in my tests thus far).
	
	NOTE: mobile targets have not been tested!
	
usage:
	var lighting = new Lighting();
	lighting.alpha = 0.7; // or whatever
	//lighting.blue = 20;   // for example
	//lighting.color = FlxColor.BLACK;
	add(lighting);
	...
	...
	var light = new FlxSprite();
	light.loadGraphic(...);
	lighting.add(light);
*/

import openfl.geom.Rectangle;
import openfl.geom.ColorTransform;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;


class Lighting extends FlxGroup
{
	var _shadowColor = new FlxColor(0x01010101);
		
	var _colorTransform = new ColorTransform(0,0,0,-1,0,0,0,255);
	
	var _boundsRect:Rectangle;
	var _shadow:FlxSprite;
	
	// 0 to 1.0
	public var alpha(get, set):Float;
	function get_alpha() { return _shadow.alpha; }
	function set_alpha(x) { return _shadow.alpha = x; }
	
	// -255 to 255
	public var red(get, set):Float;
	function get_red(){ return _colorTransform.redOffset; }
	function set_red(x){ return _colorTransform.redOffset = x; }
	
	// -255 to 255
	public var green(get, set):Float;
	function get_green(){ return _colorTransform.greenOffset; }
	function set_green(x){ return _colorTransform.greenOffset = x; }
	
	// -255 to 255
	public var blue(get, set):Float;
	function get_blue(){ return _colorTransform.blueOffset; }
	function set_blue(x){ return _colorTransform.blueOffset = x; }
	
	public var color(get, set):FlxColor;
	function get_color() { return _colorTransform.color; }
	function set_color(x:FlxColor):FlxColor
	{ 
		_colorTransform.redOffset   = x.red;
		_colorTransform.greenOffset = x.green;
		_colorTransform.blueOffset  = x.blue;
		return _colorTransform.color;
	}
	
	override public function new() {
		var w = FlxG.width;
		var h = FlxG.height;

		_shadow = new FlxSprite(0,0);
		_shadow.scrollFactor.set(0,0);
		_shadow.allowCollisions = FlxObject.NONE;
		_shadow.moves = false;
		_shadow.immovable = true;
		
		_boundsRect = new Rectangle(0, 0, w, h);
		_shadow.makeGraphic(Std.int(w), h, _shadowColor, true);
		_shadow.alpha = 1;

		super();
	}
	
	function _drawLight(light:FlxSprite):Void
	{
		if (light.graphic == null) return; // necessary?
		var pos = light.getScreenPosition();
		_shadow.stamp(light, Std.int(pos.x), Std.int(pos.y));
	}
	
	override public function draw():Void
	{
		// clear the shadow map
		_shadow.pixels.fillRect(_boundsRect, _shadowColor);

		// draw the lights into the shadow map
		this.forEachOfType(FlxSprite, _drawLight, true);

		// flip _shadow's alpha channel, making lights a cutout sprite
		_shadow.pixels.colorTransform(_boundsRect, _colorTransform);
		
		// force update for draw -- necessary?
		_shadow.drawFrame(true); 
		
		// draw the shadow map
		_shadow.draw();
	}
}
