package substates;

class PauseSubState extends MusicBeatSubstate {
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);

	public static var songName:String = null;

	override function create() {
		if(states.PlayState.chartingMode) {
			menuItems.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!states.PlayState.instance.startingSong) {
				num = 1;
				menuItems.insert(3, 'Skip Time');
			}
			menuItems.insert(3 + num, 'End Song');
		}


		pauseMusic = new FlxSound();
        pauseMusic.loadEmbedded(Paths.music('Breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, states.PlayState.SONG.song, 32);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);
		levelInfo.alpha = 0;
		levelInfo.x = FlxG.width - (levelInfo.width + 20);

		var chartingText:FlxText = new FlxText(20, 15 + 32, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = states.PlayState.chartingMode;
		add(chartingText);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});

		add(grpMenuShit = new FlxTypedGroup<Alphabet>());

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if(controls.BACK) {
			close();
			return;
		}

		updateSkipTextStuff();
		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);

		var daSelected:String = menuItems[curSelected];
		switch (daSelected) {
			case 'Skip Time':
				if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					controls.UI_LEFT_P ? curTime -= 1000 : curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT) {
					holdTime += elapsed;
					if(holdTime > 0.5) curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (controls.ACCEPT && (cantUnpause <= 0 || !controls.controllerMode)) {
			switch (daSelected) {
				case "Resume":
					close();
				case "Restart Song":
					restartSong();
				case "Leave Charting Mode":
					restartSong();
					states.PlayState.chartingMode = false;
				case 'Skip Time':
					if(curTime < Conductor.songPosition) {
						states.PlayState.startOnTime = curTime;
						restartSong(true);
					} else {
						if (curTime != Conductor.songPosition) {
							states.PlayState.instance.clearNotesBefore(curTime);
							states.PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case 'End Song':
					close();
					states.PlayState.instance.notes.clear();
					states.PlayState.instance.unspawnNotes = [];
					states.PlayState.instance.finishSong(true);
				case 'Options':
					states.PlayState.instance.paused = true;
					states.PlayState.instance.vocals.volume = 0;

					FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath('Breakfast')), pauseMusic.volume);
					FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
					FlxG.sound.music.time = pauseMusic.time;

					MusicBeatState.switchState(new options.OptionsState());

				case "Exit to menu":
					states.PlayState.deathCounter = 0;
					states.PlayState.seenCutscene = false;

					openSubState(new CustomFadeTransition(0.6, false));
					states.PlayState.isStoryMode ? CustomFadeTransition.finishCallback = function() FlxG.switchState(new states.StoryMenuState()) : CustomFadeTransition.finishCallback = function() FlxG.switchState(new states.MainMenuState());
					if (!states.PlayState.isStoryMode) states.PlayState.isFreeplay = true;

					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					states.PlayState.chartingMode = false;
					FlxG.camera.followLerp = 0;
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false) {
		states.PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		states.PlayState.instance.vocals.volume = 0;

		if(noTrans) {
			flixel.addons.transition.FlxTransitionableState.skipNextTransIn = true;
			flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;
		} else {
			flixel.addons.transition.FlxTransitionableState.skipNextTransIn = false;
			flixel.addons.transition.FlxTransitionableState.skipNextTransOut = false;
		}
		MusicBeatState.resetState();
	}

	override function destroy() {
		pauseMusic.destroy();
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'));

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0) {
				item.alpha = 1;

				if(item == skipTimeTracker) {
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time') {
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff() {
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText() {
		skipTimeText.text = flixel.util.FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + flixel.util.FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
