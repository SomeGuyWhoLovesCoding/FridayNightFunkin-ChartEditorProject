package charting.ui;

import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;

class Grid extends FlxSpriteGroup {
	var grid(default, null):FlxBackdrop;

	public function new(chart:fv.song.Chart.ChartJson):Void {
		super();

		grid = new FlxBackdrop('assets/images/charting/grid.png');
		grid.blitMode = MAX_TILES_XY(16, 4);
		add(grid);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		grid.x -= 1.0;
	}
}