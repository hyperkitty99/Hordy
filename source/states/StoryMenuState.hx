package states;

import backend.WeekData;
import objects.MenuItem;

class StoryMenuState extends MusicBeatState {
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;
	var txtWeekTitle:FlxText;

	private static var curWeek:Int = 0;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var loadedWeeks:Array<WeekData> = [];

	override function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		states.PlayState.isStoryMode = true;
		states.PlayState.isFreeplay = false;

		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;

		persistentUpdate = persistentDraw = true;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		add(new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK));

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length) {
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);

			if(!weekIsLocked(WeekData.weeksList[i]) || !weekFile.hiddenUntilUnlocked) {
				loadedWeeks.push(weekFile);

				var weekThing:MenuItem = new MenuItem(0, 452, WeekData.weeksList[i]);
				weekThing.y += ((weekThing.height + 20) * num);
				weekThing.targetY = num;
				grpWeekText.add(weekThing);
				weekThing.screenCenter(X);
				num++;
			}
		}

		add(new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFF9CF51));
		add(scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36).setFormat("VCR OSD Mono", 32));
		add(txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32).setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT));
		txtWeekTitle.alpha = 0.7;

		changeWeek();

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float) {
		lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 30)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "WEEK SCORE:" + lerpScore;

		if (!movedBack && !selectedWeek) {
			if (controls.UI_UP_P || controls.UI_DOWN_P) {
				changeWeek(controls.UI_UP_P ? -1 : 1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if(FlxG.mouse.wheel != 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeWeek(-FlxG.mouse.wheel);
			}

			if (controls.ACCEPT) selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek() {
		if (!weekIsLocked(loadedWeeks[curWeek].fileName)) {
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) songArray.push(leWeek[i][0]);

			try {
				states.PlayState.storyPlaylist = songArray;
				states.PlayState.isStoryMode = true;
				states.PlayState.isFreeplay = false;
				selectedWeek = true;
	
				states.PlayState.SONG = backend.Song.loadFromJson(states.PlayState.storyPlaylist[0].toLowerCase(), states.PlayState.storyPlaylist[0].toLowerCase());
				states.PlayState.campaignScore = 0;
				states.PlayState.campaignMisses = 0;
			}
			catch(e:Dynamic) {
				trace('ERROR! $e');
				return;
			}
			
			if (stopspamming == false) {
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].isFlashing = true;
				stopspamming = true;
			}

			new FlxTimer().start(1, function(tmr:FlxTimer) {MusicBeatState.switchState(new states.PlayState());});
		} else FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	function changeWeek(change:Int = 0):Void {
		curWeek += change;

		if (curWeek >= loadedWeeks.length) curWeek = 0;
		if (curWeek < 0) curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];

		var leName:String = leWeek.storyName;
		txtWeekTitle.text = leName.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (item in grpWeekText.members) {
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && unlocked)
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		states.PlayState.storyWeek = curWeek;

		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText() {
		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) stringThing.push(leWeek.songs[i][0]);

		intendedScore = backend.Highscore.getWeekScore(loadedWeeks[curWeek].fileName);
	}
}
