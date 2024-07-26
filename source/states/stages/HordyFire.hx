package states.stages;

class HordyFire extends BaseStage {
	var speaker2:BGSprite;
	var speaker:BGSprite;
	override function create() {
		add(new BGSprite("bgs/hordy/BombStage", -2200, -1700));
		add(speaker2 = new BGSprite("bgs/hordy/speakerB", -1200, 650, ['speakerB'], null, 1.1));
		add(speaker = new BGSprite("bgs/hordy/kolonkaB", 2250, 650, ['kolonkaB'], null, 1.1));
		add(new BGSprite("bgs/hordy/fire", 1900, -400, ['fire'], true));
	}

	override function beatHit() for (sprite in [speaker2, speaker]) sprite.dance();
}