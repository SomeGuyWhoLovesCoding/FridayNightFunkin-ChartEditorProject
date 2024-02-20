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

	override public function update(elapsed:Float):Void {
		grid.y = -inst.time;
		if (flixel.FlxG.keys.justPressed.SPACE) {
			if (@:privateAccess inst.playing) inst.pause(); else if (@:privateAccess inst.paused) inst.resume(); else inst.play();
			if (@:privateAccess voices.playing) voices.pause(); else if (@:privateAccess voices.paused) voices.resume(); else voices.play();
		}
		inst.update(elapsed);
		voices.update(elapsed);
		super.update(elapsed);
	}

	function onStepHit():Void {
		if (voices.time < inst.time - 20) {
			voices.time = inst.time;
		}
	}
}