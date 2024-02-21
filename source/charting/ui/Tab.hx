package charting.ui;

import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.*;
import charting.ui.popups.*;

class Tab extends FlxSpriteGroup {
	var bar(default, null):FlxSprite;
	var buttons(default, null):FlxSpriteGroup;
	var buttonsLength(default, null):Int = 5;
	var buttonNames(default, null):Array<String> = ['[!] Meta', 'Gameplay', 'Section', 'Events', 'File'];
	var tabPopup(default, null):TabPopup;

	public function new(chart:fv.song.Chart.ChartJson):Void {
		super();

		bar = new FlxSprite().makeGraphic(FlxG.width, 38, 0x66000000);
		add(bar);

		buttons = new FlxSpriteGroup();
		add(buttons);

		var buttonX:Float = 0.0;

		var i:Int = 0; while (i < buttonsLength) {
			var bX:Float = (bar.width / buttonsLength);
			var button = new FlxButton(buttonX, 0.0, buttonNames[i]);
			button.loadGraphic("assets/images/charting/ui/tabButton.png", true, Std.int(bX), Std.int(bar.height) /* Why are these argument integers!? */);
			button.label.font = 'assets/fonts/roman.ttf';
			button.label.color = 0xFFFFFFFF;
			button.label.size = 26;
			buttons.add(button);
			button.onUp.callback = () -> onTabButtonClick(button);
			buttonX += bX;
			i++;
		}

		tabPopup = new TabPopup(chart, onTabPopupExit);
		tabPopup.visible = false;
		add(tabPopup);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	public function onTabButtonClick(button:FlxButton):Void {
		var id:Int = buttons.members.indexOf(button);
		trace(id);
		tabPopup.change(id);
		tabPopup.visible = true;
		buttons.active = false;
		if (button != null) {
			button.status = FlxButton.NORMAL;
			button.animation.play("normal", true);
			button.label.y -= 1; // Do a little fix here
		}
	}

	public function onTabPopupExit():Void {
		tabPopup.change(-1);
		tabPopup.visible = false;
		buttons.active = true;
	}
}