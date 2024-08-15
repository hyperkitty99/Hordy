package states.stages;

class Fearless extends BaseStage {
	var bg:BGSprite;
    var explosion:BGSprite;

    var gradient:FlxSprite;
	override function create() {
		add(gradient = flixel.util.FlxGradient.createGradientFlxSprite(512, 512, [0xFF577BB8, 0xFF384855]));
        gradient.setPosition(-247, -197);

        add(bg = new BGSprite("bgs/fearless", -450, -275));
        bg.alpha = 0.00001;
	}

    override function actualCreatePost() {
        add(explosion = new BGSprite("bgs/explosion", -750, -450, ['explosion']));
        explosion.antialiasing = false;
        explosion.setGraphicSize(1550, 1120);
        explosion.updateHitbox();
        explosion.alpha = 0.00001;
    }


    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch(eventName) {
			case "Boom":
                explosion.alpha = 1;
                explosion.dance();
                FlxTimer.wait(0.29, () -> {bg.alpha = 1;});
                explosion.animation.finishCallback = function(s:String) {explosion.destroy(); gradient.destroy();}
		}
	}
}