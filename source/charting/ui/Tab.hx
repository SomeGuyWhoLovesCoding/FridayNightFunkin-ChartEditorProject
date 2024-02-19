package charting.ui;

import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.*;

class Tab extends FlxSpriteGroup {
	public var container:FlxState;

	var bar:FlxSprite;
	var buttons:FlxSpriteGroup;
	var buttonsLength:Int = 5;
	var buttonNames:Array<String> = ['[!] Meta', 'Gameplay', 'Section', 'Events', 'File'];
	var buttonCallbacks:Array<Void->Void>;

	public function new():Void {
		super();

		bar = new FlxSprite().makeGraphic(FlxG.width, 38, 0xAA000000);
		add(bar);

		buttons = new FlxSpriteGroup();
		add(buttons);

		var buttonX:Float = 0.0;
		//buttonCallbacks = [onMetaClick, onGameplayClick, onSectionClick, onEventsClick, onFileClick];

		var i:Int = 0; while (i < buttonsLength) buttons.add(new FlxButton(buttonX += ((bar.width * 0.2) * i), 0.0, buttonNames[i])); i++;
	}

	/*public function onMetaClick():Void {
		container.openSubState(new charting.ui.popups.Meta(container.Chart.Song));
	}

	public function onGameplayClick():Void {
		container.openSubState(new charting.ui.popups.Gameplay(container.Chart.Song));
	}

	public function onSectionClick():Void {
		container.openSubState(new charting.ui.popups.Section(container.Chart));
	}

	public function onEventsClick():Void {
		container.openSubState(new charting.ui.popups.Events(container.Chart));
	}

	public function onFileClick():Void {
		container.openSubState(new charting.ui.popups.File(container.Chart));
	}*/
}