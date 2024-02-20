package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;

#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	private var buffer:Float = 0.0;

	public function new(x:Float = 10.0, y:Float = 10.0, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Assets.getFont('assets/fonts/roman.ttf').fontName, 16, color);
		autoSize = LEFT;
		multiline = true;
		text = 'FPS: ';

		addEventListener("enterFrame", updateFPS);
	}

	var maxMem:Float = 0.0; // Max memory
	// Used for buffering framerate
	var bufferAmount:Float = 40.0;
	private function updateFPS(_):Void
	{
		/*if (buffer < 0) {
			buffer = bufferAmount;*/
			updateText();
			/*return;
		}
		buffer -= 1024.0 / 1048.0; // System buffer time*/
	}

	private function updateText():Void {
		var mem:Float = System.totalMemory / 1.048;
		if (mem >= maxMem) {
			maxMem = mem;
		}

		text = 'FPS: ${Math.round(1 / flixel.FlxG.elapsed)}
			Memory usage: ${flixel.util.FlxStringUtil.formatBytes(mem)} / ${flixel.util.FlxStringUtil.formatBytes(maxMem)}
			CPU usage: [Placeholder]%';

		textColor = mem >= 3000000000.0 ? 0xFFFF0000 : 0xFFFFFFFF;

		text += "\n";
	}
}