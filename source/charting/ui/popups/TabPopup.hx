package charting.ui.popups;

import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;

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
		}
	}

	private function regenerateExitButton(?callback:Void->Void):Void {
		tabExitButton = new FlxButton(tabBG.x, tabBG.y, '', callback);
		tabExitButton.loadGraphic("assets/images/charting/ui/tabPopupExitButton.png", true, 40, 40); // The X's font is salma pro btw
		tabExitButton.x = tabBG.x + (tabBG.width - tabExitButton.width);
		add(tabExitButton);
	}
}