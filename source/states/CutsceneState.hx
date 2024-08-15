package states;

import backend.VideoSprite;
import sys.thread.Thread;

class CutsceneState extends MusicBeatState {
    var video:VideoSprite;
    override function create() {
        Thread.create(()-> {
            video = new VideoSprite();
            video.setGraphicSize(1280, 720);
            video.updateHitbox();
            video.bitmap.onEndReached.add(Thread.create.bind(() -> {
                ClientPrefs.data.completedFearless = true;
                ClientPrefs.saveSettings();
                states.PlayState.seenCutscene = false;

                flixel.addons.transition.FlxTransitionableState.skipNextTransIn = true;
                flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;

                PlayState.SONG = backend.Song.loadFromJson('overturn', 'overturn');
				FlxG.sound.music.stop();

				MusicBeatState.switchState(new PlayState());
            }));
            video.load(Paths.video('fearless'));
            video.play();
            add(video);
        });
    }
}