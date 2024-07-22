package states.stages;

class HordyFire extends BaseStage {
	var speaker2:BGSprite;
	var speaker:BGSprite;
	var fire:BGSprite;
	override function create() {
		add(new BGSprite("bgs/hordy/BombStage", -2200, -1700));
		add(speaker2 = new BGSprite("bgs/hordy/speakerB", -1200, 650, ['speakerB']));
		add(speaker = new BGSprite("bgs/hordy/kolonkaB", 2250, 650, ['kolonkaB']));
		add(fire = new BGSprite("bgs/hordy/fire", 1900, -400, ['fire'], true));

		speaker.scale.x = speaker.scale.y = speaker2.scale.x = speaker2.scale.y = 1.1;
	}

	override function beatHit() {
		super.beatHit();

		speaker2.dance();
		speaker.dance();
	}
}