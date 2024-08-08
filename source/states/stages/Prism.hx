package states.stages;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import shaders.NTSCShader;

class Prism extends BaseStage {
	var hordyPlatform:BGSprite;
	var bfPlatform:BGSprite;
	var prismPlatform:BGSprite;
	var prismPart:BGSprite;
	var perspectiveFloor:BGSprite;

	var skew:shaders.SkewShader;
	var ntscShader:NTSCShader;
    var frameCount:Int = 0;
	var bg:BGSprite;
	var line:BGSprite;

	var allowMove:Bool = true;

	var idiotP:Int;
	var idiotO:Int;

	override function create() {
		add(new BGSprite("bgs/prism/sky", -1280, -535, 0, 0));

		skew = new shaders.SkewShader();

		add(perspectiveFloor = new BGSprite("bgs/prism/floor", -3100, 1215, 0.5, 0.5));
        perspectiveFloor.scale.set(2.5, 2.5);
        perspectiveFloor.shader = skew;

		var emitter = new FlxEmitter(-850, -650, 50);
		for (i in 0...50) {
			var p = new FlxParticle();

			p.loadGraphic(Paths.image('bgs/prism/rocks/rock${FlxG.random.int(1, 11)}'));
			p.scrollFactor.x = p.scrollFactor.y = FlxG.random.float(0.1, 0.7);
			emitter.add(p);

			var colorTransform = new openfl.geom.ColorTransform();

			colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 0.5 - ((0.5 - p.scrollFactor.y) * 0.5);
			colorTransform.greenOffset = (0.5 - p.scrollFactor.y) * 200 * 0.5;
			colorTransform.blueOffset = (0.5 - p.scrollFactor.y) * 200;

			@:privateAccess p.useColorTransform = true;
			@:privateAccess p.colorTransform = colorTransform;
		}

		emitter.width = FlxG.width * 2.5;
		emitter.height = FlxG.height * 1.75;
		emitter.launchMode = SQUARE;
		emitter.lifespan.set(0);
		emitter.drag.set(200, 200, 600, 600);
		emitter.angle.set(FlxG.random.float(-360, 360), FlxG.random.float(-360, 360));
        add(emitter);

		emitter.start(true);
		emitter.sort(function(order:Int, obj1:FlxParticle, obj2:FlxParticle):Int {
			return flixel.util.FlxSort.byValues(order, obj1.scrollFactor.y, obj2.scrollFactor.y);
		});

		add(bfPlatform = new BGSprite("bgs/prism/bfPlatform", 375, 305, 0.7, 0.7));
		add(hordyPlatform = new BGSprite("bgs/prism/hordyPlatform", -340, 415));
		add(prismPart = new BGSprite("bgs/prism/prismPart", 1700, 675));
		prismPart.origin.y = -50;
		add(prismPlatform = new BGSprite("bgs/prism/prismPlatform", 1600, 475));
		
		add(bg = new BGSprite("bgs/prism/phase2/bgOne", 0, 0));
		bg.scale.set(3.3325, 3.3315);
		bg.updateHitbox();
		bg.antialiasing = false;

		add(line = new BGSprite("bgs/prism/phase2/line", 0, 0));
		line.scale.set(3.3315, 3.3315);
		line.updateHitbox();

		bg.visible = line.visible = false;
	}

	override function destroy() {
		game.camGame.filters = null;
		game.camHUD.filters = null;
	}

	override function createPost() {
		game.skipCountdown = true;
		boyfriendGroup.scrollFactor.set(0.7, 0.7);
		game.useGhost = false;

		ntscShader = new NTSCShader();
        game.camGame.setFilters([new openfl.filters.ShaderFilter(ntscShader)]);
		game.camHUD.setFilters([new openfl.filters.ShaderFilter(ntscShader)]);

		bg.camera = game.camHUD;
		line.camera = game.camHUD;

		PlayState.instance.insert(members.indexOf(game.boyfriendGroup) + 1, PlayState.instance.remove(line));
	}

	override function actualCreatePost() {
		final iconP1x = game.iconP1.x;
		final iconP2x = game.iconP2.x;
		game.iconP1.x = iconP2x;
		game.iconP2.x = iconP1x;

		game.iconP1.flipX = game.iconP2.flipX = true;
		game.healthBar.leftToRight = true;
		game.healthBar.setColors(FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]), FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]));


		for (i in 0...4) {
			final idiotP = game.playerStrums.members[i].x;
			final idiotO = game.opponentStrums.members[i].x;
			game.strumLineNotes.members[Std.int(i % game.strumLineNotes.length)].x = idiotP;
			game.strumLineNotes.members[Std.int((i + 4) % game.strumLineNotes.length)].x = idiotO;
		}
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        frameCount++;
        ntscShader.uFrame.value = [frameCount];

        skew.shit.value = [(FlxG.camera.scroll.x / 1280) / 14];
		perspectiveFloor.scale.y = (-(FlxG.camera.scroll.y / 720) * 0.85) + 2.5;

		if (allowMove) {
			dadGroup.x = dadGroup.x - 5 * Math.sin((game.valuething / 2)) * elapsed * 60;
			dadGroup.y = dadGroup.y - 4 * Math.cos((game.valuething / 2) * 2) * elapsed * 60;
			prismPlatform.x = prismPlatform.x - 5 * Math.sin((game.valuething / 2)) * elapsed * 60;
			prismPlatform.y = prismPlatform.y - 4 * Math.cos((game.valuething / 2) * 2) * elapsed * 60;
	
			prismPart.x = prismPart.x - 5 * Math.sin((game.valuething / 2)) * elapsed * 60;
			prismPart.y = prismPart.y - 4 * Math.cos((game.valuething / 2) * 2) * elapsed * 60;
			prismPart.angle = prismPart.angle - 0.5 * Math.cos((game.valuething / 2)) * elapsed * 60;
	
			hordyPlatform.y = hordyPlatform.y - Math.cos(game.valuething / 8 * Math.PI) * elapsed * 60;
			gfGroup.y = gfGroup.y - Math.cos(game.valuething / 8 * Math.PI) * elapsed * 60;
	
			bfPlatform.y = bfPlatform.y - -Math.cos(game.valuething / 7 * Math.PI) * elapsed * 60;
			boyfriendGroup.y = boyfriendGroup.y - -Math.cos(game.valuething / 7 * Math.PI) * elapsed * 60;
		}

		if (!game.mustHitSection) game.moveCameraSection();
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch(eventName) {
			case "Phase change":
				if(flValue1 == null) flValue1 = 0;

				switch(flValue1) {
					case 1:
						for (chars in [boyfriendGroup, dadGroup, gfGroup]) chars.cameras = [game.camHUD];
						allowMove = false;
						boyfriendGroup.y = -200;
						gfGroup.y = -220;
						dadGroup.setPosition(1600, -260);
						prismPlatform.setPosition(1600, 475);
						prismPart.setPosition(1700, 675);
						prismPart.angle = 0;
						hordyPlatform.y = 415;
						bfPlatform.y = 305;
			
						bg.visible = line.visible = true;
					default:
						for (chars in [boyfriendGroup, dadGroup, gfGroup]) chars.cameras = [game.camGame];
						allowMove = true;
			
						bg.destroy();
						line.destroy();
				}
			case "Camera Flash":
				if(flValue1 == null) flValue1 = 0;

				if (ClientPrefs.data.flashing) game.camOther.flash(FlxColor.WHITE, flValue1, null, true);
			case "Change Icon":
				if(flValue1 == 1) {
					game.iconP1.changeIcon(game.gf.healthIcon);
					game.healthBar.setColors(FlxColor.fromRGB(game.gf.healthColorArray[0], game.gf.healthColorArray[1], game.gf.healthColorArray[2]), FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]));
					game.checkIcon();
				} else {
					game.iconP1.changeIcon(game.boyfriend.healthIcon);
					game.healthBar.setColors(FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]), FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]));
					game.checkIcon();
				}
			case "Change Character":
				game.healthBar.setColors(FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]), FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]));
		}
	}
}