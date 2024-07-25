package options;

class OptionsSubstate extends MusicBeatSubstate {
	var options:Array<String> = ['Controls', 'Adjust Delay', 'Graphics', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var onPlayState:Bool = false;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls': openSubState(new options.ControlsSubState());
			case 'Adjust Delay': openSubState(new options.NoteOffsetSubState());
			case 'Graphics': openSubState(new options.GraphicsSettingsSubState());
			case 'Gameplay': openSubState(new options.GameplaySettingsSubState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var bullShit:Int = 0;
	override function create() {
		add(grpOptions = new FlxTypedGroup<Alphabet>());
		add(selectorLeft = new Alphabet(0, 720, '>', true));
		add(selectorRight = new Alphabet(0, 720, '<', true));

		for (i in 0...options.length) {
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 720, options[i], true);
			optionText.alignment = CENTERED;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			FlxTween.tween(optionText, {y: (i * 100) + 100}, 0.6, {ease: FlxEase.expoOut});
		}

		FlxTween.tween(selectorLeft, {y: bullShit + (curSelected + 1) * 100}, 0.6, {ease: FlxEase.expoOut});
		FlxTween.tween(selectorRight, {y: bullShit + (curSelected + 1) * 100}, 0.6, {ease: FlxEase.expoOut});

		changeSelection();

		super.create();
	}

	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		super.update(elapsed);

		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);

		if (controls.BACK && (cantUnpause <= 0)) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			for (item in grpOptions.members) {
				FlxTween.tween(item, {y: 720}, 0.1, {ease: FlxEase.expoIn});
				FlxTween.tween(selectorLeft, {y: 720}, 0.1, {ease: FlxEase.expoIn});
				FlxTween.tween(selectorRight, {y: 720}, 0.1, {ease: FlxEase.expoIn});
			}
			if(onPlayState) {
				backend.StageData.loadDirectory(states.PlayState.SONG);
				MusicBeatState.switchState(new states.PlayState());
				FlxG.sound.music.volume = 0;
			} else new FlxTimer().start(0.1, function(tmr:FlxTimer) {close();});
		} else if (controls.ACCEPT && (cantUnpause <= 0)) openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0) curSelected = options.length - 1;
		if (curSelected >= options.length) curSelected = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (item.targetY == 0) {
				selectorLeft.y = item.y;
				selectorRight.y = item.y;
				selectorLeft.x = item.x - (item.width / 2) - 55;
				selectorRight.x = item.x + (item.width / 2) + 15;
			}
		}
		if (change != 0) FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy() {
		ClientPrefs.saveSettings();
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}