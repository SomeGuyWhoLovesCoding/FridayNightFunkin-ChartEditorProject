package charting.ui;

import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.*;

import charting.ui.popups.*;

class Tab extends FlxSpriteGroup {
	public var container:FlxState;

	var bar:FlxSprite;
	var buttons:FlxSpriteGroup;
	var buttonsLength:Int = 5;
	var buttonNames:Array<String> = ['[!] Meta', 'Gameplay', 'Section', 'Events', 'File'];
	var tabPopup:TabPopup;

	public function new():Void {
		super();

		bar = new FlxSprite().makeGraphic(FlxG.width, 38, 0x66000000);
		add(bar);

		buttons = new FlxSpriteGroup();
		add(buttons);

		var buttonX:Float = 0.0;
		//buttonCallbacks = [onMetaClick, onGameplayClick, onSectionClick, onEventsClick, onFileClick];

		var i:Int = 0; while (i < buttonsLength) {
			var bX:Float = (bar.width / buttonsLength);
			var button = new FlxButton(buttonX, 0.0, buttonNames[i], () -> onTabButtonClick(i));
			button.loadGraphic("assets/images/charting/ui/tabButton.png", true, Std.int(bX), Std.int(bar.height) /* Why are these argument integers!? */);
			button.label.font = 'assets/fonts/roman.ttf';
			button.label.color = 0xFFFFFFFF;
			button.label.size = 26;
			buttons.add(button);
			buttonX += bX;
			i++;
		}

		tabPopup = new TabPopup();
		tabPopup.visible = false;
		add(tabPopup);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	public function onTabButtonClick(id:Int):Void {
		tabPopup.change(id);
		tabPopup.visible = true;
		buttons.active = false;
	}

	public function onTabPopupExit():Void {
		tabPopup.change(-1);
		tabPopup.visible = false;
		buttons.active = true;
	}
}