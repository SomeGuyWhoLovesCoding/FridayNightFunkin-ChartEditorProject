package;

import charting.*;
import charting.ui.*;
import charting.ui.popups.*;

class PlayState extends flixel.FlxState
{
	var grid:Grid;
	var tab:Tab;

	var song:fv.song.Chart;

	override public function create()
	{
		flixel.FlxG.cameras.bgColor = 0xFF666666;

		song = new fv.song.Chart('test', 'hard');
		//trace(song);

		grid = new Grid(song.getData());
		add(grid);

		tab = new Tab(song.getData());
		add(tab);

		//flixel.FlxG.camera.zoom = 0.5; Testing the bpm change map...

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
