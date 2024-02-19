package charting.ui.popups;

import flixel.ui.FlxButton;
import flixel.*;
import flixel.group.FlxSpriteGroup;

class TabPopup extends FlxSpriteGroup {
	public var container:Tab;

	var tabBG:FlxSprite;
	var tabContents:FlxSpriteGroup;
	var tabExitButton:FlxButton;

	var destroyed:Bool = false;

	public function new():Void {
		super();

		// Pre-add the tab background!
		tabBG = new FlxSprite().makeGraphic(400, 400, 0xFF999999);
		tabBG.screenCenter();
		add(tabBG);

		tabContents = new FlxSpriteGroup();
		tabContents.x = tabBG.x;
		tabContents.y = tabBG.y;
		add(tabContents);

		tabExitButton = new FlxButton(tabContents.x, tabContents.y, '', container.onTabPopupExit);
		tabExitButton.loadGraphic("assets/images/charting/ui/tabPopupExitButton.png", true, 40, 40);
		tabExitButton.x = tabContents.x + (tabContents.width - tabExitButton.width);
		add(tabExitButton);
	}

	public function change(id:Int):Void {
		if (!destroyed) {
			remove(tabContents);
			remove(tabExitButton);
			// Potentially free up memory by destroying it
			tabContents.destroy();
			tabExitButton.destroy();
			destroyed = true;
		}

		if (id == -1) return;

		destroyed = false;

		tabContents = new FlxSpriteGroup();
		tabContents.x = tabBG.x;
		tabContents.y = tabBG.y;
		add(tabContents);

		tabExitButton = new FlxButton(tabContents.x, tabContents.y, '', container.onTabPopupExit);
		tabExitButton.loadGraphic("assets/images/charting/ui/tabPopupExitButton.png", true, 40, 40); // The X's font is salma pro btw
		tabExitButton.x = tabContents.x + (tabContents.width - tabExitButton.width);
		add(tabExitButton);

		switch (id) {
			case 0:
		}
	}
}