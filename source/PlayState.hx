package;

import flixel.*;
import charting.*;
import charting.ui.*;
import charting.ui.popups.*;

class PlayState extends FlxState
{
	//var grid:Grid;
	var tab:Tab;

	override public function create()
	{
		FlxG.cameras.bgColor = 0xFF666666;

		//grid = new Grid();
		//grid.container = this;
		//add(grid);

		tab = new Tab();
		tab.container = this;
		add(tab);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
