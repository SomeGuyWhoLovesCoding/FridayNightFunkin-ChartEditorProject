package charting.ui;

import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxGridOverlay;
import fv.song.Utils;
import native.Sound;

class Grid extends FlxSpriteGroup {
	var grid(default, null):flixel.FlxSprite;
	var gridSize(default, null):Int = 55;

	var curSection:Int = 0;

	var inst(default, null):Sound;
	var voices(default, null):Sound;

	var crochet(default, null):Float = 0.0;
	var stepCrochet(default, null):Float = 0.0;

	// BPM change
	var lastStepCrochet(default, null):Float = 0.0;

	var currentBpm(null, set):Float = 100.0;
	function set_currentBpm(value:Float):Float {
		lastStepCrochet = stepCrochet;
		crochet = 60000.0 / value;
		stepCrochet = crochet * 0.25;
		return currentBpm = value;
	}

	var initialBpm(null, set):Float = 100.0;
	function set_initialBpm(value:Float):Float {
		return set_currentBpm(value);
	}

	var initialTimeSignature(default, null):fv.song.Chart.ChartTimeSignature = {Steps: 4, Beats: 4, Bars: 1};
	var currentTimeSignature(default, null):fv.song.Chart.ChartTimeSignature = {Steps: 4, Beats: 4, Bars: 1};

	public function new(chart:fv.song.Chart.ChartJson):Void {
		super();

		grid = FlxGridOverlay.create(gridSize, gridSize, gridSize * 9, gridSize * (chart.Meta.TimeSignature.Steps *
			chart.Meta.TimeSignature.Beats * chart.Meta.TimeSignature.Bars),
		true, 0xFFFFFFFF, 0xFFC3C3C3); // Hmm... This might actually be better
		grid.scrollFactor.set(1.0, 1.0);
		grid.active = false;
		grid.screenCenter(X);
		add(grid);

		currentBpm = chart.Meta.BPM;
		initialBpm = chart.Meta.BPM;

		initialTimeSignature = chart.Meta.TimeSignature;
		currentTimeSignature = chart.Meta.TimeSignature;

		//trace(currentBpm, initialBpm);

		inst = new Sound(Paths.inst(chart.Meta.Song));
		voices = new Sound(Paths.voices(chart.Meta.Song));
	}

	var stepTime:Float = 0.0;
	override public function update(elapsed:Float):Void {
		stepTime += elapsed;
		@:privateAccess {
			// Sound playback
			if (flixel.FlxG.keys.justPressed.SPACE) {
				if (inst.playing) inst.pause(); else if (inst.paused) inst.resume(); else inst.play();
				if (voices.playing) voices.pause(); else if (voices.paused) voices.resume(); else voices.play();
			}
			if (flixel.FlxG.keys.justPressed.S) {
				resetTime();
			}
			if (inst.playing || voices.playing) {
				inst.update(elapsed);
				voices.update(elapsed);
				if (stepTime % elapsed * 4.0 == 0.0) onStepHit();
			}

			// Sound time
			if (flixel.FlxG.keys.justPressed.DOWN) {
				if (inst.time > inst.length - 100.0 || voices.time > inst.length - 100.0) {
					resetTime();
				}
				inst.resume();
				inst.setTime(inst.time + 100.0);
				voices.setTime(voices.time + 100.0);
				inst.pause();
			}
			if (flixel.FlxG.keys.justPressed.UP) {
				inst.resume();
				inst.setTime(inst.time - 100.0);
				voices.setTime(voices.time - 100.0);
				inst.pause();
				/*if (inst.time < 0.0 || voices.time < 0.0) { // Feel free to comment this out
					resetTime();
				}*/
			}
		}
		super.update(elapsed);
		y = flixel.math.FlxMath.lerp(y, -(gridSize * ((lastStepCrochet + (Math.max(inst.time, 0.0) - /* ??? */)) / stepCrochet)), 0.35);
		trace(inst.time);
	}

	function onStepHit():Void {
		if (voices.time < inst.time - 20) {
			voices.time = inst.time;
		}
	}

	function resetTime():Void {
		//// Put it exactly at the sound delta so it's actually on the top
		inst.setTime(0.0);
		voices.setTime(0.0);
		//y = 0.0;
	}
}