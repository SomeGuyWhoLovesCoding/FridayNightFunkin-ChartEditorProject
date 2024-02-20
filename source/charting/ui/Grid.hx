package charting.ui;

import flixel.*;
import flixel.system.FlxSound;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxGridOverlay;
import fv.song.Utils;

class Grid extends FlxSpriteGroup {
	var grid(default, null):FlxSprite;
	var gridSize:Int = 55;

	var curSection:Int = 0;

	var inst(default, null):FlxSound;
	var voices(default, null):FlxSound;

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

		inst = new FlxSound().loadEmbedded(Paths.inst(chart.Meta.Song), true);
		voices = new FlxSound().loadEmbedded(Paths.voices(chart.Meta.Song), true);
	}

	override public function update(elapsed:Float):Void {
		grid.y = -inst.time;
		if (flixel.FlxG.keys.justPressed.SPACE) {
			if (inst.playing) inst.pause(); else inst.play();
			if (voices.playing) voices.pause(); else voices.play();
		}
		super.update(elapsed);
	}

	function onStepHit():Void {
		if (voices.time < inst.time - 20) {
			voices.time = inst.time;
		}
	}
}