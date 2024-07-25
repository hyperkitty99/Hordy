package options;

class OptionsSubstate extends MusicBeatSubstate {
	var options:Array<String> = ['Controls', 'Graphics', 'Gameplay', 'Adjust Delay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var onPlayState:Bool = false;

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
	var bullShit:Int = 0;
	override function create() {
		add(grpOptions = new FlxTypedGroup<Alphabet>());

		for (i in 0...options.length) {
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 720, options[i], true);
			optionText.alignment = CENTERED;
			optionText.snapToPosition();
			grpOptions.add(optionText);
		}
		add(selectorLeft = new Alphabet(0, 720, '>', true));
		add(selectorRight = new Alphabet(0, 720, '<', true));

		changeSelection();

		super.create();
	}

	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		super.update(elapsed);

		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);

		if (isLerping) {
            selectorLeft.y = FlxMath.lerp(selectorLeft.y, grpOptions.members[curSelected].y, 0.1);
            selectorRight.y = FlxMath.lerp(selectorRight.y, grpOptions.members[curSelected].y, 0.1);

            if (Math.abs(selectorLeft.y - grpOptions.members[curSelected].y) < 1) {
                isLerping = false;
                selectorLeft.y = grpOptions.members[curSelected].y;
                selectorRight.y = grpOptions.members[curSelected].y;
            }
        }

		for (item in grpOptions.members) {
			item.y = FlxMath.lerp(item.y, (grpOptions.members.indexOf(item) * 100) + 150, 0.1);

			if (item.targetY == 0) {
				selectorRight.y = FlxMath.lerp(selectorRight.y, item.y, 0.1);
				selectorLeft.y = FlxMath.lerp(selectorLeft.y, item.y, 0.1);
				selectorRight.x = FlxMath.lerp(selectorRight.x, item.x + (item.width / 2) + 10, 0.1);
				selectorLeft.x = FlxMath.lerp(selectorLeft.x, item.x - (item.width / 2) - 55, 0.1);
			}
		}

		if (controls.BACK && (cantUnpause <= 0)) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			for (item in grpOptions.members) FlxTween.tween(item, {y: 720}, 0.1, {ease: FlxEase.expoIn});
			if(onPlayState) {
				backend.StageData.loadDirectory(states.PlayState.SONG);
				MusicBeatState.switchState(new states.PlayState());
				FlxG.sound.music.volume = 0;
			} else new FlxTimer().start(0.1, function(tmr:FlxTimer) {close();});
		} else if (controls.ACCEPT && (cantUnpause <= 0)) openSelectedSubstate(options[curSelected]);
	
		for (item in grpOptions.members) {
			controls.ACCEPT ? item.visible = false : item.visible = true;
			controls.ACCEPT ? selectorLeft.visible = false : selectorLeft.visible = true;
			controls.ACCEPT ? selectorRight.visible = false :  selectorRight.visible = true;
		}
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
                    selectorLeft.y = item.y;
                    selectorRight.y = item.y;
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