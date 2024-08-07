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
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        frameCount++;
        ntscShader.uFrame.value = [frameCount];

        skew.shit.value = [(FlxG.camera.scroll.x / 1280) / 14];
		perspectiveFloor.scale.y = (-(FlxG.camera.scroll.y / 720) / 3) + 2.5;

		//characters
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

		if (!game.mustHitSection) game.moveCameraSection();
	}
	// override function beatHit() {
	// 	super.beatHit();
	// }
}