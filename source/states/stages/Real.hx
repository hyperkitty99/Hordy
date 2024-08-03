package states.stages;

class Real extends BaseStage {
	var speakerL:BGSprite;
	override function create() {
		add(new BGSprite("bgs/real/sky", -50 * 0.5, -25 * 0.5, 0.5, 0.5));
		add(speakerL = new BGSprite("bgs/hordy/Kolonki", 1235, 155, ['kolonka'], null, 1.3));
		add(new BGSprite("bgs/real/realbg", -45, -140));
		add(new BGSprite("bgs/real/light", 105, 115));
	}

	override function beatHit() speakerL.dance();
}