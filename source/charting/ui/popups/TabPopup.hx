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
			case 0:
				var songNameBar:flixel.addons.ui.FlxInputText = new flixel.addons.ui.FlxInputText(tabBG.x + 6, tabBG.y + 6, 388,
					'assets/data/${Paths.formatToSongPath(song.Meta.Song)}/${Paths.formatToSongPath(song.Meta.Song)}', 0xFF000000, 0xFF999999);
				tabContents.add(songNameBar);
				trace(validateSongPathOf(songNameBar.text));
				trace(songNameBar.text);
				var reloadSongbutton:FlxButton = new FlxButton(songNameBar.x, songNameBar.y + (songNameBar.height + 2), 'Find chart file with specific song name', function() {
					try {
						var v:String = validateSongPathOf(songNameBar.text);
						PlayState.instance.song = new fv.song.Chart(v, '');
					} catch (e:Dynamic) {
						trace('Could not find song path of ${songNameBar.text}: $e');
					}
					flixel.FlxG.resetState();
				});
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