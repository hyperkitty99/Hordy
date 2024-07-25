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
                video.destroy();
                ClientPrefs.data.completedFearless = true;
                ClientPrefs.saveSettings();
                states.PlayState.isFreeplay = true;
                states.PlayState.seenCutscene = false;

                openSubState(new CustomFadeTransition(0.6, false));
                CustomFadeTransition.finishCallback = function() FlxG.switchState(new states.MainMenuState());
    
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
            }));
            video.load(Paths.video('fearless'));
            video.play();
            add(video);
        });
    }
}