package charting.ui;

import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxGridOverlay;
import fv.song.Utils;
import native.Sound;

typedef BPMChangeEvent = {StepTime:Float, SongTime:Float}

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
		if (value == currentBpm) return value;
		lastStepCrochet = stepCrochet;
		crochet = 60000.0 / value;
		stepCrochet = crochet * 0.25;
		return currentBpm = value;
	}

	var initialBpm(null, set):Float = 100.0;
	function set_initialBpm(value:Float):Float {
		return set_currentBpm(value);
	}

	var currentTimeSignature(default, null):fv.song.Chart.ChartTimeSignature = {Steps: 4, Beats: 4, Bars: 1};

	var bpmChangeMap:Array<BPMChangeEvent> = [];
	var currentBpmChange:BPMChangeEvent = {StepTime: 0.0, SongTime: 0.0};

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

		currentBpm = chart.Meta.BPM;
		initialBpm = chart.Meta.BPM;

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
		// BPM change map
		var i:Int = 0; while (i < bpmChangeMap.length) {
			var bpmChange:BPMChangeEvent = bpmChangeMap[i++];
			if (inst.time > bpmChange.SongTime) currentBpmChange = bpmChange;
			else if (inst.time < bpmChangeMap[0].SongTime) currentBpmChange = bpmChangeMap[0];
		}
		y = flixel.math.FlxMath.lerp(y, -gridSize * (currentBpmChange.StepTime + (Math.max(inst.time, 0.0) - currentBpmChange.SongTime) / stepCrochet), 0.35);
		trace(y);
		//trace(inst.time);
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

	function GenerateBPMChangeMap(chart:fv.song.Chart.ChartJson):Array<BPMChangeEvent> {
		var EventsMap:Array<fv.song.Chart.ChartEvent> = chart.Gameplay.Events;
		var CurrentCrochet:Float = crochet;
		var CurrentBPM:Float = initialBpm;
		var BPMChangeMap:Array<BPMChangeEvent> = [{StepTime: CurrentCrochet * 0.25, SongTime: 0.0}];
		var i:Int = 0; while (i < EventsMap.length) {
			var Event = EventsMap[i++];
			if (Event.Type == TEMPO && Event.Name == 'Change BPM') {
				BPMChangeMap.push({StepTime: CurrentCrochet * 0.25, SongTime: Event.StrumTime});
				CurrentBPM = Std.parseFloat(Event.Value1);
				CurrentCrochet = 60.0 / CurrentBPM;
			}
		}
		return BPMChangeMap;
	}
}