package states.stages;

class BuryBG extends BaseStage {
	override function create() {
		var bury:BGSprite;
		add(bury = new BGSprite("bgs/buryBG", -614, -414, 0, 0));
		bury.scale.set(1.2, 1.2);
	}
}