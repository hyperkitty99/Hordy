package states.stages;

import shaders.SkewShader;

class BuryBG extends BaseStage {
    var buryBG:BGSprite;
    var perspectiveFloor:BGSprite;
    var sword:BGSprite;

    var skew:SkewShader;
    override function create() {
        add(buryBG = new BGSprite("bgs/buryBG", -585, -414, 0.725, 0.275));
        buryBG.scale.set(1.8, 1.2);

        skew = new SkewShader();

        add(perspectiveFloor = new BGSprite("bgs/buryFloor", -520, 980, 1, 1.5));
        perspectiveFloor.scale.set(4.5, 2.4);
        perspectiveFloor.shader = skew;

        add(sword = new BGSprite("bgs/sword", -370, 695, 0.873, 0.75));
    }

    override function createPost() {
        game.boyfriend.scrollFactor.set(0.873, 0.68);
        game.dad.scrollFactor.set(0.873, 0.65);

        for (thing in [sword, dadGroup]) PlayState.instance.insert(members.indexOf(game.dadGroup) + 1, PlayState.instance.remove(thing));
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        skew.shit.value = [(FlxG.camera.scroll.x / 1280) / 7];
        perspectiveFloor.scale.y = (-(FlxG.camera.scroll.y / 720) * 3) + 2.4;

        sword.scale.y = (-(FlxG.camera.scroll.y / 720) * 0.6) + 1;
    }
}