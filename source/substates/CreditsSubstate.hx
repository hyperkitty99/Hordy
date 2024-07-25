package substates;

import objects.AttachedSprite;

class CreditsSubstate extends MusicBeatSubstate {
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var descText:FlxText;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var bar:flixel.addons.display.FlxBackdrop;

	override function create() {
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var defaultList:Array<Array<String>> = [ //Name - Description - Link
			["b"],
			['deasodiakk', "all instrumentals, almost all charts and voices for fearless and completed", 'https://fuckyou/'],
			['FlyingFeltBott', "all sprites (real)", 'https://fuckyou/'],
			['Nick', "all code stuff", 'https://fuckyou/'],
			['Iccer', "all backgrounds", 'https://fuckyou/'],
			['DenikTFA', "chart for magic soul lmao", 'https://fuckyou/'],
			['EFkli', "voices for ungrowing, shaldun", 'https://fuckyou/'],
			['tix45', "voices for mind blown", 'https://fuckyou/'],
			['Ddsad', "voices for magic soul", 'https://fuckyou/']
		];
		
		for(i in defaultList) creditsStuff.push(i);
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.changeX = false;
			optionText.targetY = 4;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			optionText.targetY = i;

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][0]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
				iconArray.push(icon);
				add(icon);

				@:privateAccess optionText.forEach(char -> {char.colorTransform.redOffset = char.colorTransform.greenOffset = char.colorTransform.blueOffset = 255; char.updateColorTransform();});

				if(curSelected == -1) curSelected = i;
			} else optionText.alignment = CENTERED;
		}

		add(bar = new flixel.addons.display.FlxBackdrop(Paths.image('ui/mainmenu/eventThing'), X));
		bar.velocity.x = 30;
		bar.x = states.MainMenuState.barD.x;
		bar.y = 615;
		bar.flipY = true;
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		descBox.sprTracker = descText;
		add(descText);

		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if(!quitting) {
			if(creditsStuff.length > 1) {
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				if (controls.UI_UP_P || controls.UI_DOWN_P) {
					changeSelection(controls.UI_UP_P ? -shiftMult : shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP) {
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0) {
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][2] == null || creditsStuff[curSelected][2].length > 4) && (cantUnpause <= 0)) FlxG.openURL(creditsStuff[curSelected][2]);

			if (controls.BACK && (cantUnpause <= 0)) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				for (item in grpOptions.members) FlxTween.tween(item, {targetY: 1000 + (curSelected * 100)}, 0.25, {ease: FlxEase.expoIn});

				new FlxTimer().start(0.1, function(tmr:FlxTimer) {close();});
				quitting = true;
			}
		}
		
		for (item in grpOptions.members) {
			if(!item.bold) {
				var lerpVal:Float = Math.exp(-elapsed * 12);
				if(item.targetY == 0) {
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(item.x - 70, lastX, lerpVal);
				} else
					item.x = FlxMath.lerp(200 + -40 * Math.abs(item.targetY), item.x, lerpVal);
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0) {
		FlxG.sound.play(Paths.sound('scrollMenu'));
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while (unselectableCheck(curSelected));

		var bullShit:Int = 0;
		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) item.targetY == 0 ? item.alpha = 1 : item.alpha = 0.6;
		}

		descText.text = creditsStuff[curSelected][1];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	private function unselectableCheck(num:Int):Bool return creditsStuff[num].length <= 1;
}
