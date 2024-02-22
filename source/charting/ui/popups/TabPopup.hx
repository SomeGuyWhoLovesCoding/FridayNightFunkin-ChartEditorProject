package charting.ui.popups;

import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;

using StringTools;

class TabPopup extends FlxSpriteGroup {
	var tabBG(default, null):flixel.FlxSprite;
	var tabContents(default, null):FlxSpriteGroup;
	var tabExitButton(default, null):FlxButton;
	var exitCallback(default, null):Void->Void;

	var song(default, null):fv.song.Chart.ChartJson;

	public function new(chart:fv.song.Chart.ChartJson, ?callback:Void->Void):Void {
		super();

		// Pre-add the tab background!
		tabBG = new flixel.FlxSprite().makeGraphic(400, 400, 0xFF999999);
		tabBG.screenCenter();
		add(tabBG);

		tabContents = new FlxSpriteGroup();
		tabContents.x = tabBG.x;
		tabContents.y = tabBG.y;
		add(tabContents);

		song = chart;

		regenerateExitButton(exitCallback = callback);
	}

	public function change(id:Int):Void {
		if (id == -1)  {
			remove(tabBG);
			remove(tabContents);
			remove(tabExitButton);

			// Potentially free up memory by destroying it
			tabBG.destroy();
			tabContents.destroy();
			tabExitButton.destroy();

			return;
		}

		tabBG = new flixel.FlxSprite().makeGraphic(400, 400, 0xFF999999);
		tabBG.screenCenter();
		add(tabBG);

		tabContents = new FlxSpriteGroup();
		tabContents.x = tabBG.x;
		tabContents.y = tabBG.y;
		add(tabContents);

		regenerateExitButton(exitCallback);

		switch (id) {
			case 4:
				var loadSongBar = new flixel.addons.ui.FlxInputText(7, 7, Std.int(tabBG.width - (13 + tabExitButton.width)), 'assets/data/${Paths.formatToSongPath(song.Meta.Song)}/${Paths.formatToSongPath(song.Meta.Song)}.json');
				tabContents.add(loadSongBar);

				var loadSongButton:FlxButton = new FlxButton(6, 7 + (loadSongBar.height + 4), 'Load chart', function() {
					try {
						PlayState.instance.song = haxe.Json.parse(sys.io.File.getContent(loadSongBar.text));
						flixel.FlxG.resetState();
					} catch (e:Dynamic) {
						trace('Could not find song path of ${loadSongBar.text}: $e');
					}
				});
				tabContents.add(loadSongButton);

				var saveSongBar = new flixel.addons.ui.FlxInputText(7, 7 + ((loadSongButton.height * 2.0) + 8), Std.int(tabBG.width - 13), 'assets/data/${Paths.formatToSongPath(song.Meta.Song)}/${Paths.formatToSongPath(song.Meta.Song)}.json');
				tabContents.add(saveSongBar);

				var saveSongButton:FlxButton = new FlxButton(6, 55 + (saveSongBar.height + 4), 'Save chart', function() {
					sys.io.File.saveContent(saveSongBar.text, haxe.Json.stringify(PlayState.instance.song, '\t'));
					PlayState.instance.song = haxe.Json.parse(sys.io.File.getContent(saveSongBar.text));
					trace('Chart successfully saved!');
				});
				tabContents.add(saveSongButton);
		}
	}

	private function regenerateExitButton(?callback:Void->Void):Void {
		tabExitButton = new FlxButton(tabBG.x, tabBG.y, '', callback);
		tabExitButton.loadGraphic("assets/images/charting/ui/tabPopupExitButton.png", true, 40, 40); // The X's font is salma pro btw
		tabExitButton.x = tabBG.x + (tabBG.width - tabExitButton.width);
		add(tabExitButton);
	}

	private function validateSongPathOf(songName:String):String {
		return songName.replace('assets/data/${Paths.formatToSongPath(song.Meta.Song)}/', '');
	}
}