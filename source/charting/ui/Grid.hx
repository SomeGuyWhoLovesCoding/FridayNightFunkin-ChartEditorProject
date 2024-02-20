package charting.ui;

import flixel.*;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxGridOverlay;
import fv.song.Utils;
import native.Sound;

class Grid extends FlxSpriteGroup {
	var grid(default, null):FlxSprite;
	var gridSize:Int = 55;

	var curSection:Int = 0;

	var inst(default, null):Sound;
	var voices(default, null):Sound;

	public function new(chart:fv.song.Chart.ChartJson):Void {
		super();

		grid = FlxGridOverlay.create(gridSize, gridSize, gridSize * 8, gridSize * (chart.Meta.TimeSignature.Steps *
			chart.Meta.TimeSignature.Beats * chart.Meta.TimeSignature.Bars),
		true, 0xFFFFFFFF, 0xFFC3C3C3); // Hmm... This might actually be better
		grid.scrollFactor.set(1, 1);
		grid.active = false;
		grid.updateHitbox();
		grid.screenCenter(X);
		add(grid);

		inst = new Sound(Paths.inst(chart.Meta.Song));
		voices = new Sound(Paths.voices(chart.Meta.Song));
	}

	var stepTime:Float = 0.0;
	override public function update(elapsed:Float):Void {
		grid.y = -inst.time;
		@:privateAccess {
			if (flixel.FlxG.keys.justPressed.SPACE) {
				if (inst.playing) inst.pause(); else if (inst.paused) inst.resume(); else inst.play();
				if (voices.playing) voices.pause(); else if (voices.paused) voices.resume(); else voices.play();
			}
			if (flixel.FlxG.keys.justPressed.S) {
				if (inst.playing || inst.paused) inst.play();
				if (voices.playing || voices.paused) voices.play();
			}
		}
		inst.update(elapsed);
		voices.update(elapsed);
		super.update(elapsed);
		stepTime += elapsed;
		if (stepTime % elapsed * 4.0 == 0) onStepHit();
	}

	function onStepHit():Void {
		if (voices.time < inst.time - 20) {
			voices.time = inst.time;
		}
	}
}