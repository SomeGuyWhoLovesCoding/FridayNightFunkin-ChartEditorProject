package;

import flixel.*;
import charting.*;
import charting.ui.*;
import charting.ui.popups.*;

class PlayState extends FlxState
{
	var grid:Grid;
	var tab:Tab;

	var song:fv.song.Chart.ChartJson;

	override public function create()
	{
		FlxG.cameras.bgColor = 0xFF666666;

		song = new fv.song.Chart('test', 'hard').getData();
		trace(song);

		grid = new Grid(song);
		add(grid);

		tab = new Tab(song);
		add(tab);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
