package states;

import flixel.addons.transition.FlxTransitionableState;

typedef CharacterStuff = {
	var x:Int;
	var y:Int;
	var name:String;
	var color:Int;
}

class MainMenuState extends MusicBeatState {
	static var curSelected:Int = 0;

	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];

	var characterShit:Array<CharacterStuff> = [
		{x: 35,  y: 35, name: 'hodry', color: 0xFF008D0B}, {x: 35,  y: 65, name: 'melol', color: 0xFF8B5632},
		{x: -130,  y: 5, name: 'nest', color: 0xFF6F00BD}, {x: 35,  y: 35, name: 'zovtan', color: 0xFF537DCE}
	];

	var menuItems:FlxTypedGroup<FlxSprite>;
	override function create() {
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var num = FlxG.random.int(0, 3);

		var checker:flixel.addons.display.FlxBackdrop = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/checker'));
		checker.velocity.set(15, -15);
		checker.color = characterShit[num].color;
		add(checker);

		var character:FlxSprite = new FlxSprite(characterShit[num].x, characterShit[num].y);
		character.frames = Paths.getSparrowAtlas('ui/mainmenu/chars');
		character.animation.addByPrefix('idle', characterShit[num].name, 0, false);
		character.animation.play('idle');
		character.updateHitbox();
		add(character);

		var barU:flixel.addons.display.FlxBackdrop = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/eventThing'), X);
		barU.velocity.x = -30;
		add(barU);

		var barD:flixel.addons.display.FlxBackdrop = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/eventThing'), X);
		barD.velocity.x = 30;
		barD.y = 615;
		barD.flipY = true;
		add(barD);

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

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * elapsed;

		if (!selectedSomethin) {
			if (controls.UI_UP_P || controls.UI_DOWN_P) changeItem(controls.UI_UP_P ? -1 : 1);

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;

				flixel.effects.FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:flixel.effects.FlxFlicker) {
					switch (optionShit[curSelected]) {
						case 'story_mode':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							MusicBeatState.switchState(new options.OptionsState());
							options.OptionsState.onPlayState = false;
							if (states.PlayState.SONG != null) {
								states.PlayState.SONG.arrowSkin = null;
								states.PlayState.SONG.splashSkin = null;
								states.PlayState.stageUI = 'normal';
							}
					}
				});

				for (i in 0...menuItems.members.length) {
					if (i == curSelected) continue;
					FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween) {menuItems.members[i].kill();}});
				}
			}

			if (controls.justPressed('debug_1')) {
				selectedSomethin = true;
				MusicBeatState.switchState(new states.editors.MasterEditorMenu());
			}
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
}