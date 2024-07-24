package states.stages;

class Hordy extends BaseStage {
	var crowd:BGSprite;
	var speakerL:BGSprite;
	var speakerR:BGSprite;
	override function create() {
		add(new BGSprite("bgs/hordy/Stage_itself", -1702, -1247));
		add(speakerL = new BGSprite("bgs/hordy/Kolonki", -1200, 650, ['kolonka'], null, 1.3));
		add(speakerR = new BGSprite("bgs/hordy/Kolonki", 2350, 650, ['kolonka'], null, 1.3));
		add(crowd = new BGSprite("bgs/hordy/Croud_bob", -650, 800, ['idle'], null, 1.5));

		speakerR.flipX = true;
	}

	override function createPost() {
		for (thing in [crowd, boyfriendGroup]) {
			PlayState.instance.remove(thing);
			PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, thing);
		}
	}

	override function beatHit() for (sprite in [crowd, speakerL, speakerR]) sprite.dance();
}