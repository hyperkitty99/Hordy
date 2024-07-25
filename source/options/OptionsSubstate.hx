package options;

class OptionsSubstate extends MusicBeatSubstate {
	var options:Array<String> = ['Controls', 'Graphics', 'Gameplay', 'Adjust Delay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Graphics': openSubState(new options.GraphicsSettingsSubState());
			case 'Controls': openSubState(new options.ControlsSubState());
			case 'Gameplay': openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay': openSubState(new options.NoteOffsetSubState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var isLerping:Bool = true;
	override function create() {
		add(grpOptions = new FlxTypedGroup<Alphabet>());
		add(selectorLeft = new Alphabet(0, 720, '>', true));
		add(selectorRight = new Alphabet(0, 720, '<', true));

		for (i in 0...options.length) {
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 720, options[i], true);
			optionText.alignment = CENTERED;
			optionText.snapToPosition();
			grpOptions.add(optionText);
		}

		changeSelection();

		super.create();
	}

	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		super.update(elapsed);

		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);

		if (isLerping) {
			for (thing in [selectorLeft, selectorRight]) thing.y = FlxMath.lerp(thing.y, grpOptions.members[curSelected].y, 0.1);

            if (Math.abs(selectorLeft.y - grpOptions.members[curSelected].y) < 1) {
                isLerping = false;
				for (thing in [selectorLeft, selectorRight]) thing.y = grpOptions.members[curSelected].y;
            }
        }

		for (item in grpOptions.members) {
			item.y = FlxMath.lerp(item.y, (grpOptions.members.indexOf(item) * 100) + 175, 0.1);

			if (item.targetY == 0) {
				for (thing in [selectorLeft, selectorRight]) thing.y = FlxMath.lerp(thing.y, item.y, 0.1);
				selectorRight.x = FlxMath.lerp(selectorRight.x, item.x + (item.width / 2) + 10, 0.1);
				selectorLeft.x = FlxMath.lerp(selectorLeft.x, item.x - (item.width / 2) - 55, 0.1);
			}
		}

		if (controls.BACK && (cantUnpause <= 0)) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			for (item in grpOptions.members) FlxTween.tween(item, {y: 720}, 0.1, {ease: FlxEase.expoIn});
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {close();});
		} else if (controls.ACCEPT && (cantUnpause <= 0)) openSelectedSubstate(options[curSelected]);
	
		for (item in grpOptions.members) for (thing in [item, selectorLeft, selectorRight]) controls.ACCEPT ? curSelected == 3 ? thing.visible = true : thing.visible = false : thing.visible = true;
	}
	
    function changeSelection(change:Int = 0) {
        curSelected += change;
        if (curSelected < 0) curSelected = options.length - 1;
        if (curSelected >= options.length) curSelected = 0;

        var bullShit:Int = 0;

        for (item in grpOptions.members) {
            item.targetY = bullShit - curSelected;
            bullShit++;

            if (item.targetY == 0) {
                if (!isLerping) {
					for (thing in [selectorLeft, selectorRight]) thing.y = item.y;
					selectorLeft.x = item.x - (item.width / 2) - 65;
					selectorRight.x = item.x + (item.width / 2) + 20;
                }
            }
        }
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }

	override function destroy() {
		ClientPrefs.saveSettings();
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}