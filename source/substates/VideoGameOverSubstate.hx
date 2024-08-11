package substates;

class VideoGameOverSubstate extends MusicBeatSubstate {
	var cutscene:PsychVideoSprite;

	public function new(path:String, ?x:Int) {
		super();

		Conductor.songPosition = 0;

		flixel.addons.transition.FlxTransitionableState.skipNextTransIn = true;
		flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		FlxG.camera.zoom = 1;
		FlxG.camera.x = FlxG.camera.y = 0;

		add(cutscene = new PsychVideoSprite());
		cutscene.x = x;
		cutscene.load(Paths.video(path));
		cutscene.play();
		cutscene.addCallback('onEnd',()->{FlxG.resetState();});
	}
}