package charting.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxGridOverlay;

class Grid extends FlxSpriteGroup {
	var grid(default, null):FlxSprite;
	var gridWidth:Int = 55;

	var curSection:Int = 0;

	public function new(chart:fv.song.Chart.ChartJson):Void {
		super();

		grid = FlxGridOverlay.create(gridWidth, gridWidth, gridWidth * 8, gridWidth * (chart.Meta.TimeSignature.Steps *
			chart.Meta.TimeSignature.Beats * chart.Meta.TimeSignature.Bars),
		true, 0xFFFFFFFF, 0xFFC3C3C3); // Hmm... This might actually be better
		grid.scrollFactor.set(1, 1);
		grid.active = false;
		grid.updateHitbox();
		grid.screenCenter(X);
		add(grid);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		grid.scroll.y;
	}
}