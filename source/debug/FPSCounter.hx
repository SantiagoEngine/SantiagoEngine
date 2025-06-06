package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import flixel.util.FlxStringUtil;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS:";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void {
		var fpsText = 'FPS: $currentFPS';
		var memoryText = 'Memory: ' + Std.string(Math.round(memoryMegas * 100) / 100) + 'MB | ${FlxStringUtil.formatBytes(System.totalMemory)}';
	
		text = fpsText + '\n' + memoryText;

		var fpsFormat = new TextFormat("VCR OSD Mono", 20, 0xFFFFFF);
		var memFormat = new TextFormat("VCR OSD Mono", 12, 0xCCCCCC);

		setTextFormat(fpsFormat, 0, fpsText.length);
		setTextFormat(memFormat, fpsText.length + 1, text.length);
	
		if (currentFPS < FlxG.drawFramerate * 0.5)
			setTextFormat(new TextFormat("VCR OSD Mono", 20, 0xFF0000), 0, fpsText.length);
	}
	

	inline function get_memoryMegas():Float
		return System.totalMemory / (1024 * 1024);
}