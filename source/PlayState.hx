package;

class PlayState extends flixel.FlxState
{
	var playfield(default, null):charting.Playfield;
	var tab(default, null):charting.ui.Tab;

	public var song:fv.song.Chart;

	public static var instance:PlayState;

	override public function create()
	{
		flixel.FlxG.cameras.bgColor = 0xFF666666;

		song = new fv.song.Chart('test', 'hard');

		playfield = new charting.Playfield(song.getData());
		add(playfield);

		tab = new charting.ui.Tab(song.getData());
		add(tab);

		instance = this;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}