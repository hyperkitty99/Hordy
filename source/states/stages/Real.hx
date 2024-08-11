	package states.stages;

	import flixel.text.FlxBitmapText;

	class Real extends BaseStage {
		var sky:BGSprite;
		// var speakerL:BGSprite;
		var text:FlxBitmapText;
		var thekeys:Array<String> = [];
		var ogKeys:Array<String>;

		override function create() {
			add(sky = new BGSprite("bgs/real/sky", -25, -12));
			sky.scrollFactor.set(0.5, 0.5);
			// add(speakerL = new BGSprite("bgs/hordy/Kolonki", 1235, 155, ['kolonka'], null, 1.3));
			add(new BGSprite("bgs/real/realbg", -45, -140));
			add(new BGSprite("bgs/real/light", 105, 115));
		}

		override function actualCreatePost() {
			add(text = new FlxBitmapText('', flixel.graphics.frames.FlxBitmapFont.fromAngelCode(Paths.image('ui/buttons'), Paths.fnt('images/ui/buttons'))));
			text.camera = game.camHUD;
			text.alpha = 0.00001;
		}

		static function retartedString(?amount:Int = 3):Array<String> {
			var exclude = [
				ClientPrefs.keyBinds.get('note_left')[0], ClientPrefs.keyBinds.get('note_down')[0], 
				ClientPrefs.keyBinds.get('note_up')[0], ClientPrefs.keyBinds.get('note_right')[0]
			];

			var chars = 'QWE${ClientPrefs.data.noReset ? 'R' : ''}TYUIOPASDFGHJKLZXCVBNM'.split('');
			for (key in exclude) chars.remove(key.toString());

			var result = [];

			while (result.length < amount) {
				var char = chars[Math.floor(Math.random() * chars.length)];
				if (result.indexOf(char) == -1) result.push(char);
			}

			return result;
		}

		var alphaTween:FlxTween;
		override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
			switch(eventName) {
				case "Create Text":
					if(alphaTween != null) alphaTween.cancel();
					alphaTween = FlxTween.tween(text, {alpha: 1}, 0.5, {ease: FlxEase.cubeOut});
					thekeys = value1 != '' ? value1.split('') : retartedString();
					ogKeys = thekeys.copy();
					updateText();

					FlxTimer.wait(flValue2 == null ? 5 : flValue2, () -> {
						thekeys = [];
						FlxTween.tween(text, {alpha: 0.00001}, 0.5, {ease: FlxEase.cubeIn, onComplete: function(twn:FlxTween) {text.text = '';}});
					});
			}
		}

		function updateText() {
			text.text = Std.string(thekeys).toUpperCase().replace('ALT', '+').replace('FOUR', '4');
			text.screenCenter();
		}

		override function update(elapsed:Float) {
			super.update(elapsed);

			if (thekeys.length > 0) {
				if (FlxG.keys.firstJustPressed() != flixel.input.keyboard.FlxKey.NONE) {
					if (FlxG.keys.firstJustPressed() == flixel.input.keyboard.FlxKey.fromString(thekeys[0])) {
						thekeys.shift();
						updateText();
			
						if (thekeys.length == 0) {
							game.boyfriend.playAnim('attack', true);
							game.boyfriend.specialAnim = true;
			
							FlxTimer.wait(0.375, () -> {
								game.dad.playAnim('hit', true);
								game.dad.specialAnim = true;
							});

							thekeys = [];
						}
					} else {
						thekeys = ogKeys.copy();
						updateText();
						FlxTween.color(text, 0.3, FlxColor.RED, FlxColor.WHITE);
					}
				}
			}
		}

		// override function beatHit() speakerL.dance();
	}