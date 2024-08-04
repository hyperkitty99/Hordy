package states.stages;

class Rooftop extends BaseStage {
	//Lisa Stage
	var cityBackBack:BGSprite;
	var cityBack:BGSprite;
	var city:BGSprite;
	var building:BGSprite;
	var floor:BGSprite;
	var speakers:BGSprite;
	var speakers2:BGSprite;
	var speakerF:BGSprite;

	//Hordy Stage
	var crowdDush:BGSprite;
	var speaker2:BGSprite;
	var speaker:BGSprite;
	var stage:BGSprite;
	var sky:FlxSprite;

	var whiteShit:FlxSprite;
	override function create() {
		//Lisa Stage
		add(sky = new FlxSprite(0, -1450).loadGraphic(Paths.image("bgs/lisa/sky")));
		sky.scrollFactor.set(0, 0);
		sky.scale.x = 6500;
		sky.screenCenter(X);

		add(cityBackBack = new BGSprite("bgs/lisa/cityBackBack", -3750, 350, 0.2, 0.2));
		add(cityBack = new BGSprite("bgs/lisa/cityBack", -3750, 350, 0.4, 0.4));
		add(city = new BGSprite("bgs/lisa/city", -4000, -200, 0.6, 0.6));
		add(building = new BGSprite("bgs/lisa/building", -2070, -2800));

		add(speakers = new BGSprite("bgs/lisa/speakers", -1580, -2180, ['speakers']));
		speakers.scale.set(1.1, 1.1);

		add(speakers2 = new BGSprite("bgs/lisa/speakers", 1760, -2180, ['speakers']));
		speakers2.scale.set(1.1, 1.1);
		speakers2.flipX = true;

		add(floor = new BGSprite("bgs/lisa/floor", -1085, -1700));
		floor.scale.set(1.05, 1.05);

		add(speakerF = new BGSprite("bgs/lisa/speakerF", -550, 1350, ['speakerF']));

		//Hordy Stage
		add(stage = new BGSprite("bgs/hordy/Stage_itself", -1702, -1047));

		add(speaker2 = new BGSprite("bgs/hordy/Kolonki", -1200, 850, ['kolonka']));
		speaker2.scale.set(1.3, 1.3);

		add(speaker = new BGSprite("bgs/hordy/Kolonki", 2350, 850, ['kolonka']));
		speaker.scale.set(1.3, 1.3);
		speaker.flipX = true;

		add(crowdDush = new BGSprite("bgs/hordy/croud_dush", -800, 1150, ['croud dush']));
		crowdDush.scale.set(1.5, 1.5);

		for (sprite in [stage, speaker2, speaker, crowdDush]) sprite.visible = false;

		add(whiteShit = new FlxSprite().makeGraphic(2900, 1500, 0xFFFFFFFF));
		whiteShit.scrollFactor.set(0, 0);
		whiteShit.screenCenter();
		whiteShit.alpha = 0;
	}

	override function createPost()
		for (thing in [whiteShit, crowdDush, boyfriendGroup]) PlayState.instance.insert(members.indexOf(game.dadGroup) + 1, PlayState.instance.remove(thing));

	override function stepHit() {
		super.stepHit();

		if (curStep == 636 || curStep == 892) FlxTween.tween(whiteShit, {alpha: 1}, 0.2, {ease:FlxEase.cubeIn});

		if (curStep == 639 || curStep == 896) {
			FlxTween.tween(whiteShit, {alpha: 0}, 0.4, {ease:FlxEase.cubeOut});

			if (curStep == 639) {
				for (sprite in [stage, speaker2, speaker, crowdDush]) sprite.visible = true;
				for (sprite in [cityBackBack, cityBack, city, building, floor, speakers, speakers2, speakerF, sky]) sprite.visible = false;
			} else {
				for (sprite in [stage, speaker2, speaker, crowdDush]) sprite.destroy();
				for (sprite in [cityBackBack, cityBack, city, building, floor, speakers, speakers2, speakerF, sky]) sprite.visible = true;
			}
		}
	}

	override function beatHit() {
		super.beatHit();

		if (curBeat >= 224 || curBeat < 160)
			for (sprite in [speakers, speakers2, speakerF]) sprite.dance();
		else 
			for (sprite in [crowdDush, speaker2, speaker]) sprite.dance();
	}
}