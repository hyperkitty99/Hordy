package states;

import shaders.NTSCShader;

typedef DevData = {var x:Int; var y:Int; var name:String; var ?desc:String;}
typedef ThxData = {var name:String; var ?credit:String; var ?size:Int;}

class PostCreditsState extends MusicBeatState {
    var devsArray:Array<DevData> = [
        {x: 225, y: 95,  name: 'bday',  desc: ''}, {x: 523, y: 185, name: 'featuring', desc: ''},
        {x: 485, y: 340, name: 'mint',  desc: "Menu Remix, V1 Instrumentals, Completed Voices, all V1 charts except Magic Soul, all meme songs, Poydem Viydem (song, chart & death cutscenes), Lock in and Explode Chart, cutscenes"},
        {x: 470, y: 570, name: 'ffb',   desc: "Completely everything about art and animations (almost), all Overturn cutscenes"},
        {x: 530, y: 760, name: 'nick',  desc: "All code stuff, help with animations & art, Vegetables 2 and Overturn Chart"},
        {x: 580, y: 940, name: 'iccer', desc: "V1 Backgrounds, да просто поздороваться."}
    ];

    var specialMeThanks:Array<ThxData> = [
        {name: 'Special Thanks:', size: 40}, {name: 'hordy17', credit: 'Twiddlefinger Remix (Vegetables 2)', size: 30}, {name: 'SansPZSG', credit: 'Overturn Song', size: 30},
        {name: 'EFkli', credit: "Ungrowing Voices, Composed Lock in and Exlplode, shaldun", size: 30}, {name: 'tix45', credit: "Mind Blown Voices", size: 30},
        {name: 'Ddsad', credit: "Magic Soul Voices", size: 30}, {name: 'DenikTFA', credit: "Magic Soul Chart", size: 30}
    ];

	var devs:FlxTypedGroup<BGSprite>;
    var devsDesc:FlxTypedGroup<FlxText>;

    var specialDevs:FlxTypedGroup<FlxText>;
    var specialDevsDesc:FlxTypedGroup<FlxText>;

	var ntscShader:NTSCShader;
    var video:backend.VideoSprite;
    var frameCount:Int = 0;
    override function create() {
        super.create();

        FlxG.camera.scroll.y = -650;

        video = new backend.VideoSprite();
        video.scrollFactor.set();
        states.PlayState.seenCutscene = true;
        video.bitmap.onEndReached.add(() -> {
            FlxTween.tween(video, {alpha: 0.5}, 1, {ease: FlxEase.linear});
            ClientPrefs.data.completedFearless = true;
            ClientPrefs.saveSettings();
            states.PlayState.seenCutscene = false;
        });
        video.load(Paths.video('postCredits'));
        video.play();
        add(video);

        add(devs = new FlxTypedGroup());
        add(devsDesc = new FlxTypedGroup());

        add(specialDevs = new FlxTypedGroup());
        add(specialDevsDesc = new FlxTypedGroup());

		for (i in 0...devsArray.length) {
            final dev = new BGSprite('ui/lazyCredits/devs', devsArray[i].x, devsArray[i].y, [devsArray[i].name], true);
            dev.dance();
			devs.add(dev);

            if(devsArray[i].desc != '') {
                final devDesc = new FlxText(285, devsArray[i].y + devs.members[i].height + 33, 710, devsArray[i].desc).setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER);
                devsDesc.add(devDesc).active = false;
            }
		}

        for (i in 0...specialMeThanks.length) {
            final devSpecial = new FlxText(50, 1220 + (i * 100), 830, specialMeThanks[i].name).setFormat(Paths.font("vcr.ttf"), specialMeThanks[i].size, FlxColor.WHITE);
            specialDevs.add(devSpecial).active = false;

            if(specialMeThanks[i].credit != '') {
                final devspecialDesc = new FlxText(70, specialDevs.members[i].y + 33, 830, specialMeThanks[i].credit).setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE);
                specialDevsDesc.add(devspecialDesc).active = false;
            }
        }

        final thx = new FlxText(285, 1885, 710, 'THANKS FOR PLAYING!!\n\n\n\n17+1').setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, CENTER);
        add(thx).active = false;

        if (ClientPrefs.data.shaders) {
			ntscShader = new NTSCShader();
			FlxG.camera.setFilters([new openfl.filters.ShaderFilter(ntscShader)]);
		}

        FlxTimer.wait(8.25, () -> {FlxG.camera.filters = null;});
    }

    override function destroy() {
        super.destroy();
        if(FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('freakyMenu'));
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (ClientPrefs.data.shaders && FlxG.camera.filters != null) {
			frameCount++;
			ntscShader.uFrame.value = [frameCount];
		}

        if (!states.PlayState.seenCutscene) {
            if (FlxG.camera.scroll.y != 2000)
                FlxG.camera.scroll.y += 0.25 * (FlxG.keys.pressed.SHIFT ? 2 : 1);
            else
                MusicBeatState.switchState(new MainMenuState());
        }

        if (controls.BACK) MusicBeatState.switchState(new MainMenuState());
    }
}