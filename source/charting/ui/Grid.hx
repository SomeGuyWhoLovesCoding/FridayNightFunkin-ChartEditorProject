package charting.ui;

import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxGridOverlay;
import fv.song.Utils;
import native.Sound;

typedef BPMChangeEvent = {BPM:Float, StrumTime:Float}

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

	var initialBpm(default, null):Float = 100.0;

	var currentBpm(null, set):Float = 100.0;
	function set_currentBpm(value:Float):Float {
		if (value == currentBpm) return value;
		crochet = 60000.0 / value;
		stepCrochet = crochet * 0.25;
		return currentBpm = value;
	}

	var timeOffset(default, null):Float = 0.0;
	var songPosition(default, null):Float = 0.0;

	var currentTimeSignature(default, null):fv.song.Chart.ChartTimeSignature = {Steps: 4, Beats: 4, Bars: 1};

	var bpmChangeMap(default, null):Array<BPMChangeEvent> = [];

	final smoothGrid:Bool = true;

	public function new(chart:fv.song.Chart.ChartJson):Void {
		super();

		currentTimeSignature = chart.Meta.TimeSignature;

		grid = FlxGridOverlay.create(gridSize, gridSize, gridSize * 9,
			gridSize * (currentTimeSignature.Steps * currentTimeSignature.Beats * currentTimeSignature.Bars),
				true, 0xFFFFFFFF, 0xFFC3C3C3); // Hmm... This might actually be better
		grid.scrollFactor.set(1.0, 1.0);
		grid.active = false;
		grid.screenCenter(X);
		add(grid);

		initialBpm = chart.Meta.BPM;
		currentBpm = chart.Meta.BPM;

		//trace(currentBpm, initialBpm);

		inst = new Sound(Paths.inst(chart.Meta.Song));
		voices = new Sound(Paths.voices(chart.Meta.Song));

		bpmChangeMap = GenerateBPMChangeMap(chart);
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
				if (inst.paused) inst.resume(); else inst.play();
				if (voices.paused) voices.resume(); else voices.play();
				inst.setTime(inst.time + 100.0);
				inst.pause();
				voices.setTime(voices.time + 100.0);
				voices.pause();
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
		songPosition = Math.max(inst.time, 0.0);
		currentBpm = GenerateBPMFromBPMChangeMap(songPosition);
		trace(currentBpm,stepCrochet);
		y = flixel.math.FlxMath.lerp(y, -gridSize * (songPosition - timeOffset) / stepCrochet, smoothGrid ? 0.35 : 1.0);
		//trace(y);
		//trace(inst.time);
	}

	inline function onStepHit():Void {
		if (voices.time < inst.time - 20) {
			voices.time = inst.time;
		}
	}

	inline function resetTime():Void {
		//// Put it exactly at the sound delta so it's actually on the top
		var startTime:Float = 0.0;
		inst.setTime(startTime);
		voices.setTime(startTime);
		inst.time = startTime;
		voices.time = startTime;
		// Don't remove this, otherwise the bpm won't change back.
		currentBpm = initialBpm;
		timeOffset = startTime;
		//
		songPosition = startTime;
		y = startTime;
	}

	inline function GenerateBPMChangeMap(chart:fv.song.Chart.ChartJson):Array<BPMChangeEvent> {
		var EventsMap:Array<fv.song.Chart.ChartEvent> = chart.Gameplay.Events;
		var CurrentCrochet:Float = crochet;
		var BPMChangeMap:Array<BPMChangeEvent> = [{BPM: initialBpm, StrumTime: 0.0}];
		var i:Int = 0; while (i < EventsMap.length) {
			var Event = EventsMap[i++];
			if (Event.Type == TEMPO && Event.Name == 'Change BPM') {
				BPMChangeMap.push({BPM: Std.parseFloat(Event.Value1), StrumTime: Event.StrumTime});
			}
		}
		return BPMChangeMap;
	}

	inline function GenerateBPMFromBPMChangeMap(position:Float):Float {
		var bpm:Float = currentBpm;
		var i:Int = 0; while (i < bpmChangeMap.length) {
			var bpmChange:BPMChangeEvent = bpmChangeMap[i++];
			if (position > bpmChange.StrumTime) {
				var lastBpm:Float = bpm;
				bpm = bpmChange.BPM;
				timeOffset = bpmChange.StrumTime * (lastBpm / bpm);
			}
		}
		return bpm;
	}
}