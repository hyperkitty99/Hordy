package states.stages;

class Prism extends BaseStage {
	var platform:BGSprite;
	override function create() {
		add(platform = new BGSprite("bgs/platform", -1305, 335));
	}
	override function createPost() gf.origin.set(platform.x + gf.origin.x - platform.x, platform.y + gf.origin.y - platform.y);

	override function update(elapsed:Float) {
		super.update(elapsed);

		platform.angle += 0.1;
		gf.angle = platform.angle;
		boyfriend.angle = platform.angle;
	}

	// override function createPost() for (thing in [crowd, boyfriendGroup]) PlayState.instance.insert(members.indexOf(game.dadGroup) + 1, PlayState.instance.remove(thing));
	// override function beatHit() for (sprite in [crowd, speakerL, speakerR]) sprite.dance();
}