package substates;

import objects.Character;
import flixel.FlxObject;

class LazyGameOverSubstate extends MusicBeatSubstate {
	public var boyfriend:Character;
	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;

	public static var characterName:String = '';
	public static var deathSoundName:String = 'boom';

	public static var instance:LazyGameOverSubstate;

	public static function resetVariables() {
		deathSoundName = 'boom';

		var _song = states.PlayState.SONG;
		if(_song != null) {
			characterName = _song.player1;
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
		}
	}

	override function create() {
		instance = this;

		Conductor.songPosition = 0;

		boyfriend = new Character(states.PlayState.instance.boyfriend.getScreenPosition().x, states.PlayState.instance.boyfriend.getScreenPosition().y, characterName, true);
		boyfriend.x += boyfriend.positionArray[0] - states.PlayState.instance.boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1] - states.PlayState.instance.boyfriend.positionArray[1];
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0], boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1]);
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 9999);
		flixel.addons.transition.FlxTransitionableState.skipNextTransOut = false;

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		
		if (boyfriend.animation.curAnim != null) if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished) FlxG.resetState();
		if (FlxG.sound.music.playing) Conductor.songPosition = FlxG.sound.music.time;
	}

	override function destroy() {
		instance = null;
		super.destroy();
	}
}
