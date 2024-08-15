package substates;

import objects.Character;
import flixel.FlxObject;

class LazyGameOverSubstate extends MusicBeatSubstate {
	public var boyfriend:Character;
	var camFollow:FlxObject;

	override function create() {
		Conductor.songPosition = 0;

		add(boyfriend = new Character(states.PlayState.instance.boyfriend.getScreenPosition().x, states.PlayState.instance.boyfriend.getScreenPosition().y, states.PlayState.boyfriendGhost.curCharacter, true));
		boyfriend.x += boyfriend.positionArray[0] - states.PlayState.instance.boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1] - states.PlayState.instance.boyfriend.positionArray[1];

		FlxG.sound.play(Paths.sound('boom'));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		add(camFollow = new FlxObject(0, 0, 1, 1));
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0] - 90, boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1] - 380);
		FlxG.camera.follow(camFollow, LOCKON, 9999);
		flixel.addons.transition.FlxTransitionableState.skipNextTransIn = true;
		flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished) FlxG.resetState();
	}
}
