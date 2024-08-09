package states.stages;

class HordyAI extends BaseStage {
	var crowd:BGSprite;
	var speakerL:BGSprite;
	var speakerR:BGSprite;


	override function create() {
		add(new BGSprite("bgs/hordy/Stage_itselfAI", -1702, -1247));

		add(speakerL = new BGSprite("bgs/hordy/KolonkiAI", -1200, 650, ['kolonka']));
		speakerL.scale.set(1.3, 1.3);

		add(speakerR = new BGSprite("bgs/hordy/KolonkiAI", 2350, 650, ['kolonka']));
		speakerR.scale.set(1.3, 1.3);
		speakerR.flipX = true;

		add(crowd = new BGSprite("bgs/hordy/Croud_bobAI", -650, 800, ['idle']));
		crowd.scale.set(1.5, 1.5);
	}

	override function createPost()
		for (thing in [crowd, boyfriendGroup]) PlayState.instance.insert(members.indexOf(game.dadGroup) + 1, PlayState.instance.remove(thing));

	override function beatHit() {
		super.beatHit();

		if (curBeat % 2 == 0) {
			crowd.dance();
			speakerL.dance();
			speakerR.dance();
		}
	}
}