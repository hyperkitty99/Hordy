package states;

import flixel.addons.transition.FlxTransitionableState;

typedef CharacterStuff = {
	var x:Int;
	var y:Int;
	var name:String;
	var color:Int;
}

class MainMenuState extends MusicBeatState {
	public static var curSelected:Int = 0;

	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];

	var characterShit:Array<CharacterStuff> = [
		{x: 35,  y: 35, name: 'hodry', color: 0xFF51B867}, {x: 35,  y: 65, name: 'melol', color: 0xFF8B5632},
		{x: -130,  y: 5, name: 'nest', color: 0xFF7B48DA}, {x: 35,  y: 35, name: 'zovtan', color: 0xFF537DCE}
	];

	var barU:flixel.addons.display.FlxBackdrop;
	public static var barD:flixel.addons.display.FlxBackdrop;
	var checker:flixel.addons.display.FlxBackdrop;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var character:FlxSprite;
	var num:Int;
	var prevNum:Int = -1;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create() {
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		while (num == prevNum) num = FlxG.random.int(0, 3);
		prevNum = num;

		add(checker = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/checker')));
		checker.velocity.set(15, -15);
		checker.color = characterShit[num].color;

		character = new FlxSprite(characterShit[num].x, characterShit[num].y);
		character.frames = Paths.getSparrowAtlas('ui/mainmenu/chars');
		character.animation.addByPrefix('idle', characterShit[num].name, 0, false);
		character.animation.play('idle');
		character.updateHitbox();
		add(character);

		add(barU = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/eventThing'), X));
		barU.velocity.x = -30;

		add(barD = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/eventThing'), X));
		barD.velocity.x = 30;
		barD.y = 615;
		barD.flipY = true;

		add(menuItems = new FlxTypedGroup<FlxSprite>());

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(600, (i * 150) + 75);
			menuItem.frames = Paths.getSparrowAtlas('ui/mainmenu/buttons');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		checker.color = characterShit[num].color;
		intendedColor = checker.color;

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * elapsed;

		if (num != prevNum) prevNum = num;

		if (PlayState.isFreeplay) {
			selectedSomethin = true;

			for (i in 0...menuItems.members.length) {
				menuItems.members[i].x = 1700;
				menuItems.members[i].alpha = 0;
			}

			character.x = -character.height;
			if(colorTween != null) colorTween.cancel();
			menuItems.visible = false;

			openSubState(new substates.FreeplaySubstate());

			subStateClosed.add((substateThing) -> if (substateThing is substates.FreeplaySubstate) {
				selectedSomethin = false;
				menuItems.visible = true;
				for (i in 0...menuItems.members.length) {
					menuItems.members[i].revive();
					menuItems.members[i].alpha = 1;
				}

				while (num == prevNum) num = FlxG.random.int(0, 3);

				character.animation.addByPrefix('idle', characterShit[num].name, 0, false);
				character.animation.play('idle');
				character.y = characterShit[num].y;
				character.updateHitbox();
			});
		}

		if (!selectedSomethin) {
			if (controls.UI_UP_P || controls.UI_DOWN_P) changeItem(controls.UI_UP_P ? -1 : 1);

			if (controls.ACCEPT) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;

				for (i in 0...menuItems.members.length) FlxTween.tween(menuItems.members[i], {x: 1700}, 0.25, {ease: FlxEase.expoIn});
				FlxTween.tween(character, {x: -character.height}, 0.25, {ease: FlxEase.expoIn});

				switch (optionShit[curSelected]) {
					case 'story_mode':
						MusicBeatState.switchState(new StoryMenuState());
					case 'freeplay':
						openSubState(new substates.FreeplaySubstate());
						flixel.effects.FlxFlicker.stopFlickering(menuItems.members[curSelected]);

						subStateClosed.add((substateThing) -> if (substateThing is substates.FreeplaySubstate) {
							selectedSomethin = false;

							while (num == prevNum) num = FlxG.random.int(0, 3);

							character.animation.addByPrefix('idle', characterShit[num].name, 0, false);
							character.animation.play('idle');
							character.y = characterShit[num].y;
							character.updateHitbox();
						});
					case 'credits':
						openSubState(new substates.CreditsSubstate());
						flixel.effects.FlxFlicker.stopFlickering(menuItems.members[curSelected]);

						subStateClosed.add((substateThing) -> if (substateThing is substates.CreditsSubstate) {
							selectedSomethin = false;

							while (num == prevNum) num = FlxG.random.int(0, 3);

							character.animation.addByPrefix('idle', characterShit[num].name, 0, false);
							character.animation.play('idle');
							character.y = characterShit[num].y;
							character.updateHitbox();
						});
					case 'options':
						MusicBeatState.switchState(new options.OptionsState());
						options.OptionsState.onPlayState = false;
						if (states.PlayState.SONG != null) {
							states.PlayState.SONG.arrowSkin = null;
							states.PlayState.SONG.splashSkin = null;
							states.PlayState.stageUI = 'normal';
						}
				}
			}

			if (controls.justPressed('debug_1')) {
				selectedSomethin = true;
				MusicBeatState.switchState(new states.editors.MasterEditorMenu());
			}
		}

		if (!selectedSomethin) {
			for (i in 0...menuItems.members.length) menuItems.members[i].x = FlxMath.lerp(menuItems.members[i].x, 600, 0.1);
			character.x = FlxMath.lerp(character.x, characterShit[num].x, 0.1);
		}

		var newColor:Int = characterShit[num].color;
		if(newColor != intendedColor) {
			if(colorTween != null) colorTween.cancel();

			intendedColor = newColor;
			colorTween = FlxTween.color(checker, 1, checker.color, intendedColor, {onComplete: function(twn:FlxTween) {colorTween = null;}});
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0) {
		menuItems.members[curSelected].animation.play('idle');
		curSelected += huh;

		if (huh != 0) FlxG.sound.play(Paths.sound('scrollMenu'));
		if (curSelected >= menuItems.length) curSelected = 0;
		if (curSelected < 0) curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
	}

	override public function draw():Void {
        super.draw();

		for (i in 0...menuItems.members.length) {
			if (menuItems.members[i].x > 600) {
				if (barD != null && curSelected != 2) barD.draw();
				if (barU != null) barU.draw();
				if (menuItems != null) menuItems.draw();
			}
		}
    }
}