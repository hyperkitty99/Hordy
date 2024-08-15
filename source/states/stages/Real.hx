package states.stages;

import objects.HealthIcon;

class Real extends BaseStage {
	var sky:BGSprite;
	var ball:BGSprite;
	var light:BGSprite;
	var uselessJunk:BGSprite;
	var bfStupid:objects.Character = null;
	var resetKey:Bool = ClientPrefs.data.noReset;

	override function create() {
		add(sky = new BGSprite("bgs/real/sky", -25, -12));
		sky.scrollFactor.set(0.5, 0.5);
		add(new BGSprite("bgs/real/podiesd", 1165, 145));
		add(uselessJunk = new BGSprite("bgs/real/ropinReal", 1225, 135, ['ropinReal'], false));
		add(new BGSprite("bgs/real/realbg", -45, -140));
		add(light = new BGSprite("bgs/real/light", 105, 115));
		add(ball = new BGSprite("bgs/real/ball", 675, 280, ['ball'], false));
		ball.alpha = 0.00001;

		BaseStage.set_customDeath('maniac_death');
	}

	var gfIcon:HealthIcon;

	override function actualCreatePost() {
		PlayState.instance.insert(members.indexOf(game.boyfriendGroup) + 1, PlayState.instance.remove(ball));
		PlayState.instance.insert(members.indexOf(game.dadGroup) + 1, PlayState.instance.remove(light));

		for (i in 1...4) Paths.sound('hit/hit$i');
			
		ClientPrefs.data.noReset = true;

		game.boyfriendGroup.add(bfStupid = new objects.Character(0, 0, 'hordyReal', true));
		game.startCharacterPos(bfStupid);

		gfIcon = new HealthIcon(game.gf.healthIcon, false);
		game.uiGroup.add(gfIcon);
		gfIcon.setPosition(game.healthBar.x - gfIcon.width / 2, game.healthBar.y - 75);
		gfIcon.offset.set(45, 45);

		for (thing in [gf, bfStupid, gfIcon]) thing.alpha = 0.00001;
	}

	override function destroy() ClientPrefs.data.noReset = resetKey;

	inline function createSmoke() {
		var smoke = new BGSprite("bgs/real/smoke", 835, 100, ['smoke'], false);
		smoke.alpha = 0.5;
		add(smoke);
		smoke.dance();
		smoke.animation.finishCallback = function(s:String) {smoke.destroy();}
		PlayState.instance.insert(members.indexOf(game.dadGroup) + 1, PlayState.instance.remove(smoke));
	}

	override function opponentNoteHit(note:objects.Note) {
		if (note.noteType == 'GF Sing' && gf.animation.curAnim.name == 'singUP') createSmoke();
		if (!game.dad.stunned && game.health > 0.05) game.set_health(game.health - 0.0175);
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch(eventName) {
			case "Create Text":
				var typeSub = new substates.TextSubstate(value1, Std.parseInt(value2));
				typeSub.camera = game.camHUD;
				game.blockControls = true;

				typeSub.kingGG = () -> {
					game.blockControls = false;
					game.boyfriend.playAnim('attack', true);
					game.boyfriend.specialAnim = true;
					ball.alpha = 1;
					ball.dance();
					ball.animation.finishCallback = function(s:String) {ball.alpha = 0.00001;}
		
					FlxTimer.wait(0.375, () -> {
						game.set_health(game.health + 0.5);
						FlxG.sound.play(Paths.soundRandom('hit/hit', 1, 3));
						game.dad.playAnim('hit', true);
						game.dad.specialAnim = true;
						game.dad.stunned = true;
						game.dad.animation.finishCallback = function(s:String) {game.dad.stunned = false;}
					});
				};

				typeSub.GGgnik = () -> game.blockControls = false;

				FlxG.state.openSubState(typeSub);
			case "Play Animation":
				if (gf.animation.curAnim != null && gf.animation.curAnim.name == 'attack') {
					FlxTimer.wait(0.5, () -> {
						if (game.health > 0.05) game.set_health(game.health - 0.565);
						bfStupid.alpha = 1;
						boyfriend.alpha = 0.00001;
						bfStupid.playAnim('hit', true);
						bfStupid.specialAnim = true;
						bfStupid.animation.finishCallback = function(s:String) {bfStupid.alpha = 0.00001; boyfriend.alpha = 1;}
					});
				}
		}
	}

	override function stepHit() {
		super.stepHit();

		if (curStep == 1194) {
			gf.alpha = 0.5;
			BaseStage.set_customDeath('maniac_death_zovtan');
		}

		if (curStep == 1205) FlxTween.tween(gfIcon, {alpha: 1}, 0.5, {ease: FlxEase.cubeOut});
	}

	// override function update(elapsed:Float) {
	// 	super.update(elapsed);
	// }

	override function moveCamera(isDad:Bool) game.defaultCamZoom = (isDad ? 1 : 0.7);

	override function beatHit() {
		super.beatHit();

		if (curBeat % 2 == 0) uselessJunk.dance();
	}
}