package states;

class CutsceneState extends flixel.addons.ui.FlxUIState {
    var video:backend.VideoSprite;
    public function new(name:String) {
        super();

        video = new backend.VideoSprite();
        video.bitmap.onEndReached.add(() -> {
            states.PlayState.seenCutscene = false;

            flixel.addons.transition.FlxTransitionableState.skipNextTransIn = true;
            flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;

            PlayState.SONG = backend.Song.loadFromJson('overturn', 'overturn');
			FlxG.sound.music.stop();

			MusicBeatState.switchState(new PlayState());
        });
        video.load(Paths.video(name));
        video.play();
        add(video);
    }

    override function destroy() {
        super.destroy();
        remove(video);
		video = flixel.util.FlxDestroyUtil.destroy(video);
    }
}