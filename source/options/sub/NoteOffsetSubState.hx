package options;

import objects.Bar;
import sys.thread.Thread;

class NoteOffsetSubState extends MusicBeatSubstate {
	var barPercent:Float = 0;
	var delayMin:Int = -500;
	var delayMax:Int = 500;
	var timeBar:Bar;
	var timeTxt:FlxText;
	var beatText:Alphabet;
	var beatTween:FlxTween;

	override public function create() {
		FlxG.sound.pause();

		var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0.5;
		add(black);

		beatText = new Alphabet(FlxG.width / 2, 0, 'Beat Hit!', true);
		beatText.setScale(0.6, 0.6);
		beatText.alpha = 0;
		beatText.acceleration.y = 250;
		add(beatText);

		timeTxt = new FlxText(0, 575	, FlxG.width, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.antialiasing = ClientPrefs.data.antialiasing;
		timeTxt.borderSize = 2;

		barPercent = ClientPrefs.data.noteOffset;
		updateNoteDelay();
		
		timeBar = new Bar(0, timeTxt.y + (timeTxt.height / 3), 'healthBar', function() return barPercent, delayMin, delayMax);
		timeBar.screenCenter(X);
		timeBar.leftBar.color = FlxColor.LIME;
		timeBar.antialiasing = ClientPrefs.data.antialiasing;
		add(timeBar);
		add(timeTxt);

		Thread.create(()-> {
			FlxG.sound.playMusic(Paths.music('offsetSong'), 0.6, true);
        });
		Conductor.bpm = 128;
		super.create();
	}

	var holdTime:Float = 0;
	override public function update(elapsed:Float) {
		var addNum:Int = 1;
		if(FlxG.keys.pressed.SHIFT || FlxG.gamepads.anyPressed(LEFT_SHOULDER)) addNum = 3;

		if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
			barPercent = Math.max(delayMin, Math.min(ClientPrefs.data.noteOffset + (controls.UI_LEFT_P ? -1 : 1), delayMax));
			updateNoteDelay();
		}

		var mult:Int = 1;
		if(controls.UI_LEFT || controls.UI_RIGHT) {
			holdTime += elapsed;
			if(controls.UI_LEFT) mult = -1;
		}

		if(controls.UI_LEFT_R || controls.UI_RIGHT_R) holdTime = 0;

		if(holdTime > 0.5) {
			barPercent += 100 * addNum * elapsed * mult;
			barPercent = Math.max(delayMin, Math.min(barPercent, delayMax));
			updateNoteDelay();
		}

		if(controls.RESET) {
			holdTime = 0;
			barPercent = 0;
			updateNoteDelay();
		}

		if(controls.BACK) {
			if(zoomTween != null) zoomTween.cancel();
			if(beatTween != null) beatTween.cancel();
			FlxG.camera.zoom = 1;
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			ClientPrefs.saveSettings();
			close();
		}

		Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
	}

	var zoomTween:FlxTween;
	override public function beatHit() {
		super.beatHit();

		if(curBeat % 2 == 0) {
			FlxG.camera.zoom = 1.025;
			if(zoomTween != null) zoomTween.cancel();
			zoomTween = FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){zoomTween = null;}});
		}
		
		if(curBeat % 4 == 2) {
			beatText.alpha = 1;
			beatText.y = 320;
			beatText.velocity.y = -150;
			if(beatTween != null) beatTween.cancel();
			beatTween = FlxTween.tween(beatText, {alpha: 0}, 1, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween){beatTween = null;}});
			FlxG.camera.zoom = 1.04;
			if(zoomTween != null) zoomTween.cancel();
			zoomTween = FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){zoomTween = null;}});
		}
	}

	function updateNoteDelay() {
		ClientPrefs.data.noteOffset = Math.round(barPercent);
		timeTxt.text = 'Current offset: ' + Math.floor(barPercent) + ' ms';
	}
}