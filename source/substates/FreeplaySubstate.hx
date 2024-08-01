package substates;

import states.PlayState;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

import objects.HealthIcon;

import flixel.math.FlxMath;

class FreeplaySubstate extends MusicBeatSubstate
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var lerpSelected:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;

	private var iconArray:Array<HealthIcon> = [];

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	private var targetYOffset:Float = 0;
	private var currentYOffset:Float = 0;
	var thekeys:Array<String> = ['EIGHT', 'TWO', 'TWO'];
	var textTween:FlxTween;
	override function create() {
		persistentUpdate = true;
		if (states.PlayState.isFreeplay) openSubState(new CustomFadeTransition(0.6, true));

		states.PlayState.isStoryMode = false;
		states.PlayState.isFreeplay = false;
		WeekData.reloadWeekFiles(false);

		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			for (song in leWeek.songs) addSong(song[0], i, song[1]);
		}

		if (ClientPrefs.data.completedFearless) addSong('fearless', 3, 'icon-sexmusichordymale');

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName.replace('-', ' '), true);
			songText.targetY = i;
			grpSongs.add(songText);

			songText.scaleX = Math.min(1, 980 / songText.width);
			songText.snapToPosition();

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			songText.visible = songText.active = songText.isMenuItem = false;
			icon.visible = icon.active = false;
			iconArray.push(icon);
			add(icon);

			for (i in 0...WeekData.weeksList.length) {
					if(weekIsLocked(WeekData.weeksList[1])) {
						songText.text = '??????';
						icon.color = FlxColor.BLACK;
					}
			}
		}

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		if(curSelected >= songs.length) curSelected = 0;
		lerpSelected = curSelected;
		
		changeSelection();

		targetYOffset = 500 + (curSelected * 100);
		currentYOffset = targetYOffset;
		updateTexts();
		targetYOffset = 0;
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String) songs.push(new SongMetadata(songName, weekNum, songCharacter));
	
	function weekIsLocked(name:String):Bool return (!WeekData.weeksLoaded.get(name).startUnlocked && WeekData.weeksLoaded.get(name).weekBefore.length > 0 && (!states.StoryMenuState.weekCompleted.exists(WeekData.weeksLoaded.get(name).weekBefore) || !states.StoryMenuState.weekCompleted.get(WeekData.weeksLoaded.get(name).weekBefore)));

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			
		if(songs.length > 1) {
			if(FlxG.keys.justPressed.HOME || FlxG.keys.justPressed.END)
			{
				FlxG.keys.justPressed.HOME ? curSelected = 0 : curSelected = songs.length - 1;
				changeSelection();
				holdTime = 0;	
			}

			if (controls.UI_UP_P || controls.UI_DOWN_P) {
				changeSelection(controls.UI_UP_P ? -1 : 1);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP) {
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -1 : 1));
			}

			if(FlxG.mouse.wheel != 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-1 * FlxG.mouse.wheel, false);
			}
		}

		if (!ClientPrefs.data.completedFearless) {
			if (FlxG.keys.anyPressed([thekeys[0]])) thekeys.remove(thekeys[0]);

			if (thekeys[0] == 'TWO') {
				persistentUpdate = false;
				states.PlayState.SONG = Song.loadFromJson('fearless', 'fearless');
				states.PlayState.isStoryMode = false;
	
				openSubState(new CustomFadeTransition(0.6, false));
				CustomFadeTransition.finishCallback = function() FlxG.switchState(new states.PlayState());
			}
		}

		if (controls.BACK && (cantUnpause <= 0)) {
			persistentUpdate = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			targetYOffset = 500 + (curSelected * 100);
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				close();
			});
		}

		if (controls.ACCEPT && (cantUnpause <= 0)) {
			for (i in 0...WeekData.weeksList.length) {
				if(weekIsLocked(WeekData.weeksList[1])) {
					FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
	
					if(textTween != null) textTween.cancel();
					textTween = FlxTween.color(grpSongs.members[curSelected], 0.5, 0xFFFF4444, 0xFFFFFFFF, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween) {textTween = null;}});
				} else if(!weekIsLocked(WeekData.weeksList[1])) {
					persistentUpdate = false;

					states.PlayState.SONG = Song.loadFromJson(Highscore.formatSong(Paths.formatToSongPath(songs[curSelected].songName)), Paths.formatToSongPath(songs[curSelected].songName));
					states.PlayState.isStoryMode = false;

					openSubState(new CustomFadeTransition(0.6, false));
					CustomFadeTransition.finishCallback = function() FlxG.switchState(new states.PlayState());
				}
			}
		}

		if (currentYOffset != targetYOffset) {
			currentYOffset = FlxMath.lerp(currentYOffset, targetYOffset, elapsed * 10);
			if (Math.abs(currentYOffset - targetYOffset) < 0.01) currentYOffset = targetYOffset;
		}

		updateTexts(elapsed);
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0, playSound:Bool = true) {
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0) curSelected = songs.length - 1;
		if (curSelected >= songs.length) curSelected = 0;

		for (i in 0...iconArray.length) iconArray[i].alpha = 0.6;

		var bullShit:Int = 0;
		for (item in grpSongs.members) {
			bullShit++;
			item.alpha = 0.6;
			if (item.targetY == curSelected) item.alpha = 1;
		}

		iconArray[curSelected].alpha = 1;

		states.PlayState.storyWeek = songs[curSelected].week;
	}

	var _drawDistance:Int = 4;
	var _lastVisibles:Array<Int> = [];
	public function updateTexts(elapsed:Float = 0.0) {
		lerpSelected = FlxMath.lerp(curSelected, lerpSelected, Math.exp(-elapsed * 9.6));
		for (i in _lastVisibles) {
			grpSongs.members[i].visible = grpSongs.members[i].active = false;
			iconArray[i].visible = iconArray[i].active = false;
		}
		_lastVisibles = [];

		var min:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected - _drawDistance)));
		var max:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected + _drawDistance)));
		for (i in min...max) {
			var item:Alphabet = grpSongs.members[i];
			item.visible = item.active = true;
			item.x = ((item.targetY - lerpSelected) * item.distancePerItem.x) + item.startPosition.x;
			item.y = ((item.targetY - lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y + currentYOffset;

			var icon:HealthIcon = iconArray[i];
			icon.visible = icon.active = true;
			_lastVisibles.push(i);
		}
	}	
}

class SongMetadata {
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String) {
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		if(this.folder == null) this.folder = '';
	}
}