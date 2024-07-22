package states.stages;

class Hordy extends BaseStage {
	var croud_bob:BGSprite;
	var speaker2:BGSprite;
	var speaker:BGSprite;
	override function create() {
		add(new BGSprite("bgs/hordy/Stage_itself", -1702, -1247));
		add(speaker2 = new BGSprite("bgs/hordy/Kolonki", -1200, 650, ['kolonka']));
		add(speaker = new BGSprite("bgs/hordy/Kolonki", 2350, 650, ['kolonka']));
		add(croud_bob = new BGSprite("bgs/hordy/Croud_bob", -650, 800, ['idle']));

		speaker.flipX = true;
		croud_bob.scale.set(1.5, 1.5);
		for (sprite in [speaker, speaker2]) sprite.scale.set(1.3, 1.3);
	}

	override function createPost() {
		for (element in [croud_bob, boyfriendGroup]) PlayState.instance.remove(element);
		for (element in [croud_bob, boyfriendGroup]) PlayState.instance.insert(Std.int(members.indexOf(game.dadGroup)) + 1, element);
	}

	override function beatHit() for (sprite in [croud_bob, speaker2, speaker]) sprite.dance();
}