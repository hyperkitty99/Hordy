package substates;

import flixel.text.FlxBitmapText;

class TextSubstate extends MusicBeatSubstate {
    var prompt:Array<String>;
    var ogPrompt:Array<String>;

    public var kingGG:()->Void;
    public var GGgnik:()->Void;

    var text:FlxBitmapText;
    var theTimer:FlxText;
    var time:Int;

    var second:FlxTimer;
    public function new(?string:String, ?time:Int = 11) {
        super();
        this.time = time;

        prompt = string != '' ? string.split('') : randomString().split('');
        ogPrompt = prompt.copy();

        add(text = new FlxBitmapText('', flixel.graphics.frames.FlxBitmapFont.fromAngelCode(Paths.image('ui/buttons'), Paths.fnt('images/ui/buttons'))));
		add(theTimer = new FlxText(FlxG.width / 2 - 15, 400, 0).setFormat(Paths.font("FallingSkyBlk.otf"), 32, FlxColor.WHITE, CENTER));

        for (alphas in [theTimer, text]) {
            alphas.alpha = 0.00001;

            FlxTween.tween(alphas, {alpha: 1}, 0.15, {ease: FlxEase.cubeOut});
            FlxTimer.wait(time, () -> {FlxTween.tween(alphas, {alpha: 0}, 0.15, {ease: FlxEase.cubeIn, onComplete: _ -> {close(); GGgnik();}});});
        }

        updateText();
        timerElapsed(second = new FlxTimer());
    }

    inline function randomString() return haxe.Json.parse(File.getContent(Paths.json('poydem-viydem/words')).trim()).words[Std.random(haxe.Json.parse(File.getContent(Paths.json('poydem-viydem/words')).trim()).words.length)];

    function updateText() {
        text.text = prompt.join('').toUpperCase().replace('ALT', '+');
        text.screenCenter();
    }

    function timerElapsed(timer:FlxTimer) {
        if (time > 0) time--;
        theTimer.text = '$time';
        timer.start(1, timerElapsed);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (prompt.length > 0 && FlxG.keys.firstJustPressed() != flixel.input.keyboard.FlxKey.NONE) {
            if (FlxG.keys.firstJustPressed() == flixel.input.keyboard.FlxKey.fromString(prompt[0].replace('4', 'FOUR').replace('6', 'SIX').replace('7', 'SEVEN').replace('1', 'ONE').replace('+', 'ALT'))) {
                do {prompt.shift();} while (prompt.length > 0 && prompt[0] == ' ');
                updateText();
                if (prompt.length == 0) {
                    kingGG();
                    close();
                }
            } else {
                prompt = ogPrompt.copy();
                updateText();
                FlxTween.color(text, 0.3, FlxColor.RED, FlxColor.WHITE);
            }
        }
    }
}