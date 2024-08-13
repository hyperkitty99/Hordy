package options;

class OptionsState extends MusicBeatState {
	var options:Array<String> = ['Controls', 'Graphics', 'Gameplay', 'Adjust Delay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls': openSubState(new options.sub.ControlsSubState());
			case 'Graphics': openSubState(new options.sub.GraphicsSettingsSubState());
			case 'Gameplay': openSubState(new options.sub.GameplaySettingsSubState());
			case 'Adjust Delay': openSubState(new options.sub.NoteOffsetSubState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	override function create() {
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		add(bg);

		add(grpOptions = new FlxTypedGroup<Alphabet>());
		for (i in 0...options.length) {
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		add(selectorLeft = new Alphabet(0, 0, '>', true));
		add(selectorRight = new Alphabet(0, 0, '<', true));

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);


		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			backend.StageData.loadDirectory(states.PlayState.SONG);
			MusicBeatState.switchState(new states.PlayState());
			FlxG.sound.music.volume = 0;
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);

		for (item in grpOptions.members) for (thing in [item, selectorLeft, selectorRight]) controls.ACCEPT ? curSelected == 3 ? thing.visible = true : thing.visible = false : thing.visible = true;
	}

	function changeSelection(change:Int = 0) {
		if (change != 0) FlxG.sound.play(Paths.sound('scrollMenu'));
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);

		var bullShit:Int = 0;
		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorRight.x = item.x + item.width + 15;
				selectorLeft.y = item.y;
				selectorRight.y = item.y;
			}
		}
	}

	override function destroy() {
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}