package substates;

import objects.Character;
import flixel.FlxObject;

import states.StoryMenuState;
import states.FreeplayState;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = states.PlayState.SONG;
		if(_song != null) {
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
	}

	var charX:Float = 0;
	var charY:Float = 0;
	override function create()
	{
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
		FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2)));
		add(camFollow);

		super.create();
	}

	public var startedDeath:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
			FlxG.sound.music.stop();
			states.PlayState.deathCounter = 0;
			states.PlayState.seenCutscene = false;
			states.PlayState.chartingMode = false;

			if (states.PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		
		if (boyfriend.animation.curAnim != null)
		{
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
				boyfriend.playAnim('deathLoop');

			if(boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if(boyfriend.animation.curAnim.curFrame >= 12 && !moveCamera)
				{
					FlxG.camera.follow(camFollow, LOCKON, 0.6);
					moveCamera = true;
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					coolStartDeath();
				}
			}
		}
		
		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
		}
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}
