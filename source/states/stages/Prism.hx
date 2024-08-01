package states.stages;

class Prism extends BaseStage {
	var platform:BGSprite;
	var floor:objects.FlxPenis;
	override function create() {
		add(floor = new objects.FlxPenis('bgs/pol', -2450, 1300, 0.5, 0.5));
		add(platform = new BGSprite("bgs/platform", -1300, 405));
	}

	override function createPost() {
		boyfriendGroup.scrollFactor.set(0.7, 0.7);
		game.useGhost = false;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		dadGroup.x = dadGroup.x - 5 * Math.sin((game.valuething / 2)) * elapsed * 60;
		dadGroup.y = dadGroup.y - 4 * Math.cos((game.valuething / 2) * 2) * elapsed * 60;
		platform.y = platform.y - Math.cos(game.valuething / 8 * Math.PI) * elapsed * 60;
		gfGroup.y = gfGroup.y - Math.cos(game.valuething / 8 * Math.PI) * elapsed * 60;

		if (!game.mustHitSection) game.moveCameraSection();
	}
	// override function beatHit() {
	// 	super.beatHit();
	// }
}