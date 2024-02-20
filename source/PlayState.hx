package;

class PlayState extends flixel.FlxState
{
	var playfield:charting.Playfield;
	var tab:charting.ui.Tab;

	var song:fv.song.Chart;

	override public function create()
	{
		flixel.FlxG.cameras.bgColor = 0xFF666666;

		song = new fv.song.Chart('test', 'hard');

		playfield = new charting.Playfield(song.getData());
		add(playfield);

		tab = new charting.ui.Tab(song.getData());
		add(tab);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}