package states;

typedef CharacterInfo = {var x:Int; var y:Int; var name:String; var color:Int;}

class MainMenuState extends MusicBeatState {
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];
	var characterShit:Array<CharacterInfo> = [
		{x: 35, y: 35, name: 'hodry', color: 0xFF75D48A}, {x: 35, y: 65, name: 'melol', color: 0xFF8B5632},
		{x: -130, y: 5, name: 'nest', color: 0xFF965FA1}, {x: 35, y: 35, name: 'zovtan', color: 0xFF688EDA},
		{x: -70, y: 35, name: 'notready4sex', color: 0xFF965FA1}, {x: 80, y: 40, name: 'ready4sex', color: 0xFFDBAF5E},
		{x: 120, y: 63, name: 'fearless', color: 0xFFCF5775}, {x: -5, y: 90, name: 'monak', color: 0xFF965FA1}
	];

	public static var curSelected:Int = 0;
	var num:Int = FlxG.random.int(0, 7);
	var prevNum:Int;
	var intendedColor:Int;

	var barU:flixel.addons.display.FlxBackdrop;
	public static var barD:flixel.addons.display.FlxBackdrop;
	var checker:flixel.addons.display.FlxBackdrop;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var character:BGSprite;

	var colorTween:FlxTween;
	var selectedSomethin:Bool = false;

	override function create() {
		super.create();

		transIn = flixel.addons.transition.FlxTransitionableState.defaultTransIn;
		transOut = flixel.addons.transition.FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		while (num == prevNum) num = FlxG.random.int(0, 7);
		prevNum = num;

		add(checker = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/checker')));
		checker.velocity.set(15, -15);

		add(character = new BGSprite('ui/mainmenu/chars', characterShit[num].x, characterShit[num].y, [characterShit[num].name], false));
		character.updateHitbox();

		add(barU = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/eventThing'), X));
		barU.velocity.x = -30;

		add(barD = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/eventThing'), X));
		barD.velocity.x = 30;
		barD.y = 615;
		barD.flipY = true;

		add(menuItems = new FlxTypedGroup<FlxSprite>());

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(600, (i * 150) + 80);
			menuItem.frames = Paths.getSparrowAtlas('ui/mainmenu/buttons');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		changeItem();

		intendedColor = checker.color = characterShit[num].color;
	}

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * elapsed;
		if (num != prevNum) prevNum = num;

		if (PlayState.isFreeplay) {
			selectedSomethin = true;

			for (i in 0...menuItems.members.length) menuItems.members[i].x = 1700;
			character.x = -character.width;

			openSubState(new substates.FreeplaySubstate());
			onSubstateClosed();
		}

		if (!selectedSomethin) {
			if (controls.UI_UP_P || controls.UI_DOWN_P) changeItem(controls.UI_UP_P ? -1 : 1);

			if (controls.ACCEPT) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;

				for (i in 0...menuItems.members.length) FlxTween.tween(menuItems.members[i], {x: 1700}, 0.25, {ease: FlxEase.expoIn});
				FlxTween.tween(character, {x: -character.width}, 0.25, {ease: FlxEase.expoIn});

				switch (optionShit[curSelected]) {
					case 'story_mode': MusicBeatState.switchState(new StoryMenuState());
					case 'freeplay': openSubState(new substates.FreeplaySubstate());
					case 'credits': openSubState(new substates.CreditsSubstate());
					case 'options': openSubState(new options.OptionsSubstate());
				}
				onSubstateClosed();
			}

			for (i in 0...menuItems.members.length) menuItems.members[i].x = FlxMath.lerp(menuItems.members[i].x, 600, 0.1);
			character.x = FlxMath.lerp(character.x, characterShit[num].x, 0.1);
		}

		if(characterShit[num].color != intendedColor) {
			intendedColor = characterShit[num].color;

			if(colorTween != null) colorTween.cancel();
			colorTween = FlxTween.color(checker, 1, checker.color, intendedColor, {onComplete: function(twn:FlxTween) {colorTween = null;}});
		}

		super.update(elapsed);
	}

	function onSubstateClosed() {
		subStateClosed.add((substateThing) -> if (substateThing is substates.FreeplaySubstate || substateThing is substates.CreditsSubstate || substateThing is options.OptionsSubstate) {
			selectedSomethin = false;

			while (num == prevNum) num = FlxG.random.int(0, 7);

			character.animation.addByPrefix('idle', characterShit[num].name, 0, false);
			character.animation.play('idle');
			character.y = characterShit[num].y;
			character.updateHitbox();
		});
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
				if (barD != null && curSelected != 2 && curSelected != 3) barD.draw();
				if (barU != null) barU.draw();
				if (menuItems != null) menuItems.draw();
			}
		}
    }
}