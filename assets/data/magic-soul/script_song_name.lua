function onCreate()
	makeLuaSprite('bgThing', 'songBG', -500, 250)
    scaleObject('bgThing', 0.5, 0.43)
	setObjectCamera('bgThing', 'hud')
    addLuaSprite('bgThing', true)
    setScrollFactor('bgThing', 0, 0)
    setProperty('bgThing.alpha', tonumber(0.7))


    makeLuaText('songText', "".. songName.. " - ".. ' By deasodiakk, Ddsad', 650, getProperty('bgThing.x') - 180, 320)
    setObjectCamera("songText", 'hud');
    setTextColor('songText', '0xffffff')
    setTextSize('songText', 30);
    addLuaText("songText");
    setTextFont('songText', "vcr.ttf")
    setTextAlignment('songText', 'left')
    

    makeLuaText('beforeSongText', "Now Playing... ", 300, getProperty('bgThing.x') + 100 - 40, 270)
    setObjectCamera("beforeSongText", 'hud');
    setTextColor('beforeSongText', '0xffffff')
    setTextSize('beforeSongText', 25);
    addLuaText("beforeSongText");
    setTextFont('beforeSongText', "vcr.ttf")
    setTextAlignment('beforeSongText', 'left')
end

function onCreatePost()
    doTweenX('bgThingMoveIn', 'bgThing', -50, 0.6, 'expoOut')
    doTweenX('bgThingText', 'songText', 20, 0.6, 'expoOut') 
    doTweenX('bgThingTextBleb', 'beforeSongText', 20, 0.6, 'expoOut')
    runTimer('moveOut', 3.7, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'moveOut' then
        doTweenX('bgThingLeave', 'bgThing', -700, 0.6, 'expoIn')
        doTweenX('bgThingLeaveText', 'songText', -700, 0.6, 'expoIn')
        doTweenX('bgThingLeavePreText', 'beforeSongText', -400, 0.6, 'expoIn')
    end
end

function onTweenCompleted(tag)
    if tag == 'bgThingLeave' then
        removeLuaSprite('bgThing', true)
        removeLuaText('songText', true)
        removeLuaText('beforeSongText', true)
    end
end