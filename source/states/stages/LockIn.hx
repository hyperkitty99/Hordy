package states.stages;

import shaders.ScaryShader.ScaryEffect;
import shaders.NoiseShader.NoiseEffect;

class LockIn extends BaseStage {
    var fire:PsychVideoSprite;
    var scary = new ScaryEffect();
    var noiseEffect = new NoiseEffect();
    override function create() {
        var bg = new BGSprite("bgs/lockin", -585, -350, 0, 0);
        bg.scale.set(1.2, 1.2);
        add(bg);
    }

    override function actualCreatePost() {
        fire = new PsychVideoSprite();
        fire.load(Paths.video('fire'), [PsychVideoSprite.muted, PsychVideoSprite.looping]);
        fire.addCallback('onFormat',()->{
            fire.blend = openfl.display.BlendMode.ADD;
            fire.alpha = 0.00001;
        });
        add(fire);
        fire.camera = game.camOther;

        if(ClientPrefs.data.shaders) {
            game.cameraTransform(cam -> {
                if (cam.filters == null) cam.filters = [];
                cam.filters.push(new openfl.filters.ShaderFilter(scary.shader));
            });
        }
    }

    override function stepHit() {
        super.stepHit();

        if (curStep > 787) noiseEffect.time += FlxG.elapsed * 26;

        if (curStep == 400 || curStep == 1044) {
            game.camOther.flash(FlxColor.WHITE, 0.5, null, true);
            FlxTween.tween(fire, {alpha: 0.4}, 0.5, {ease: FlxEase.linear});
            fire.play();

            if (ClientPrefs.data.shaders) {
                scary.strength = 4.0;
                scary.darkness = 0.6;
            }
        }

        if (curStep == 788) {
            game.camOther.flash(FlxColor.WHITE, 0.5, null, true);
            FlxTween.tween(fire, {alpha: 0.00001}, 0.5, {ease: FlxEase.linear});
            fire.stop();

            game.cameraTransform(cam -> {
                if (cam.filters == null) cam.filters = [];
                cam.filters.push(new openfl.filters.ShaderFilter(noiseEffect.shader));
            });

            if (ClientPrefs.data.shaders) {
                scary.strength = 1.0;
                scary.darkness = 0.0;
            }
        }
    }

    override function destroy() {
        super.destroy();
        game.camGame.filters = game.camHUD.filters = null;

        if (fire != null) remove(fire);
        fire = flixel.util.FlxDestroyUtil.destroy(fire);
    }
}