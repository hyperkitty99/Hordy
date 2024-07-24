package states.stages;

class Rooftop extends BaseStage {
	var speakers:BGSprite;
	var speakers2:BGSprite;
	var speakerF:BGSprite;

	var croud_dash:BGSprite;
	var speaker2:BGSprite;
	var speaker:BGSprite;
	var stage:BGSprite;
	var sky:BGSprite;

	var whiteShit:BGSprite;
	var bg:BGSprite;
	override function create() {
		add(sky = new BGSprite("bgs/lisa/sky", -3750, -3350, 0, 0, null, null, 8000, 1));
		sky.updateHitbox();

		add(new BGSprite("bgs/lisa/cityBackBack", -3750, 350, 0.2, 0.2));
		add(new BGSprite("bgs/lisa/cityBack", -3750, 350, 0.4, 0.4));
		add(new BGSprite("bgs/lisa/city", -4000, -200, 0.6, 0.6));
		add(new BGSprite("bgs/lisa/building", -2070, -2800));
		add(speakers = new BGSprite("bgs/lisa/speakers", -1580, -2180, ['speakers'], null, 1.1));
		add(speakers2 = new BGSprite("bgs/lisa/speakers", 1760, -2180, ['speakers'], null, 1.1));
		add(new BGSprite("bgs/lisa/floor", -1085, -1700, null, null, 1.05));
		add(speakerF = new BGSprite("bgs/lisa/speakerF", -550, 1350, ['speakerF']));

		speakers2.flipX = true;

		add(bg = new BGSprite(null, -3750, -3350, 0, 0, null, null, 8000, 1).makeLeGraphic(1, 7321, 0xFF280828));
		bg.updateHitbox();

		add(stage = new BGSprite("bgs/hordy/Stage_itself", -1702, -1047));
		add(speaker2 = new BGSprite("bgs/hordy/Kolonki", -1200, 850, ['kolonka'], null, 1.3));
		add(speaker = new BGSprite("bgs/hordy/Kolonki", 2350, 850, ['kolonka'], null, 1.3));
		add(croud_dash = new BGSprite("bgs/hordy/croud_dush", -200, 1150, ['croud dush'], null, 1.5));

		add(whiteShit = new BGSprite(null, -614, -414, 0, 0, null, null, 1.2).makeLeGraphic(2304, 1360, 0xFFFFFFFF).center());
		whiteShit.updateHitbox();

		speaker.flipX = true;
		for (sprite in [stage, speaker2, speaker, croud_dash, bg, whiteShit]) sprite.alpha = 0.000001;
	}

	override function createPost() {
		for (thing in [whiteShit, croud_dash, boyfriendGroup]) {
			PlayState.instance.remove(thing);
			PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, thing);
		}
	}

	override function stepHit() {
		if (curStep == 636 || curStep == 892) FlxTween.tween(whiteShit, {alpha: 1}, 0.2, {ease:FlxEase.cubeIn});

		if (curStep == 639 || curStep == 896) {
			FlxTween.tween(whiteShit, {alpha: 0}, 0.4, {ease:FlxEase.cubeOut});
			curStep == 639 ? for (sprite in [stage, speaker2, speaker, croud_dash, bg, whiteShit]) sprite.alpha = 1 : for (sprite in [stage, speaker2, speaker, croud_dash, bg]) sprite.destroy();
		}
	}

	override function beatHit() {
		super.beatHit();

		curBeat >= 224 ? for (sprite in [speakers, speakers2, speakerF]) sprite.dance() : for (sprite in [speakers, speakers2, speakerF, croud_dash, speaker2, speaker]) sprite.dance();
	}
}