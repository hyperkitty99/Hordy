package states.stages;

class Rooftop extends BaseStage {
	var speakers:BGSprite;
	var speakers2:BGSprite;
	var speakerF:BGSprite;
	override function create() {
		var floor:BGSprite;
		add(new BGSprite("bgs/lisa/sky", -5500, -3350, 0, 0));
		add(new BGSprite("bgs/lisa/cityBackBack", -3750, 350, 0.2, 0.2));
		add(new BGSprite("bgs/lisa/cityBack", -3750, 350, 0.4, 0.4));
		add(new BGSprite("bgs/lisa/city", -4000, -200, 0.6, 0.6));
		add(new BGSprite("bgs/lisa/building", -2030, -2800));
		add(speakers = new BGSprite("bgs/lisa/speakers", -1580, -2180, ['speakers']));
		add(speakers2 = new BGSprite("bgs/lisa/speakers", 1750, -2180, ['speakers']));
		add(floor = new BGSprite("bgs/lisa/floor", -1085, -1700));
		add(speakerF = new BGSprite("bgs/lisa/speakerF", -450, 1350, ['speakerF']));

		speakers.scale.x = speakers.scale.y = speakers2.scale.x = speakers2.scale.y = 1.1;
		speakers2.flipX = true;
		floor.scale.set(1.05, 1.05);
	}

	override function beatHit() {
		super.beatHit();

		speakers.dance();
		speakers2.dance();
		speakerF.dance();
	}
}