package native;

import lime.media.*;

using StringTools;

/**
 * A frame buffer based sound system.
*/

class Sound {
	public var rate(default, set):Float = 1;
	private function set_rate(value:Float):Float {
		setRate(value);
		rate = value;
		return value;
	}
	public var time:Float = 0;
	public var length:Float = 0;
	public var timeLeft:Float = 0;
	public var volume:Float = 1;

	var playing:Bool = false;
	var paused:Bool = false;

	var __buffer:Null<AudioBuffer> = null;
	var __source:Null<AudioSource> = null;

	var __fileExists:Bool = false;

	final timeFix:Float = 6.666666666;

	//public static var crash:Bool = false;

	public function new(soundPath:flixel.system.FlxAssets.FlxSoundAsset):Void {
		/*#if cpp
		cpp.vm.Gc.enable(false); //prevent lag spikes where it matters most (From https://github.com/UmbratheUmbreon/PublicDenpaEngine/blob/main/source/PlayState.hx#L488-L490)
		#end*/
		__fileExists = sys.FileSystem.exists(soundPath);
		if (!__fileExists) {
			flixel.FlxG.log.error('native.Sound.hx: No sound file of "$soundPath" exists.');
			return;
		}
		__buffer = AudioBuffer.fromFile(soundPath);
		openfl.Lib.current.stage.addEventListener("enterFrame", (?event) -> update(400.0 / 60.0));
	}

	public function play():Void {
		stop();
		if (__fileExists) {
			if (!playing) {
				__source = new AudioSource(__buffer, 0, __buffer.data.length);
				__source.play();
				playing = true;
			}
		}
	}

	public function update(elapsed:Float):Void {
		if (__fileExists) {
			if (__source != null) {
				time = __source.currentTime - elapsed;
				__source.gain = volume * (flixel.FlxG.sound.muted ? 0 : flixel.FlxG.sound.volume);
				//trace('Time: $time, Length: $length, Time left: $timeLeft');
			}
			length = (__buffer.data.length / __buffer.sampleRate * 500.0) / __buffer.channels; // My own formula!
			timeLeft = length - time;

			/*// Not sure if it does replicate the classic game crash sound but whatever
			if (crash) {
				while(true) {
					if (__source != null) {
						time = __source.currentTime - (1 / elapsed);
						__source.gain = volume * (flixel.FlxG.sound.muted ? 0 : flixel.FlxG.sound.volume);
					}
				}
			}*/
		}
	}

	public function pause():Void {
		if (__fileExists) {
			if (playing && !paused && __source != null) {
				__source.pause();
				playing = false;
				paused = true;
			}
		}
	}

	public function resume():Void {
		if (__fileExists) {
			if (!playing && paused && __source != null) {
				var pauseTime:Int = __source.currentTime;
				__source.stop();
				__source.play();
				__source.currentTime = pauseTime;
				playing = true;
				paused = false;
			}
		}
	}

	public function stop():Void {
		if (__fileExists) {
			if (playing && !paused && __source != null) {
				__source.stop();
				playing = false;
			}
		}
	}

	public function setRate(value:Float):Void {
		if (__fileExists) if (__source != null) __source.pitch = value;
	}

	public function setTime(value:Float):Void {
		if (__fileExists) if (__source != null) __source.currentTime = Std.int(value + timeFix);
	}

	/*public function setVolume(value:Float):Void {
		if (__source != null) __source.gain = value;
	}*/

	public function dispose():Void {
		if (__fileExists) {
			if (__source != null) {
				__source.dispose();
			}
			if (__buffer != null) {
				__buffer.dispose();
			}
		}
	}
}