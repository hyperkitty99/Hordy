package objects;

class BGSprite extends FlxSprite {
	private var idleAnim:String;
	public function new(image:String, x:Float = 0, y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1, ?animArray:Array<String> = null, ?loop:Bool = false, ?scaleX:Float = 1, ?scaleY:Float = null, ?flipx:Bool = false, ?flipy:Bool = false) {
		super(x, y);

		if (animArray != null) {
			frames = Paths.getSparrowAtlas(image);
			for (i in 0...animArray.length) {
				animation.addByPrefix(animArray[i], animArray[i], 24, loop);
				if(idleAnim == null) {
					idleAnim = animArray[i];
					animation.play(animArray[i]);
				}
			}
		} else {
			if(image != null) loadGraphic(Paths.image(image));
			active = false;
		}

		scrollFactor.set(scrollX, scrollY);
		scale.set(scaleX, scaleY == null ? scaleX : scaleY);
		flipX = flipx;
		flipY = flipy;
	}

	public function dance(?forceplay:Bool = false):Void if (idleAnim != null) animation.play(idleAnim, forceplay);

	public function makeLeGraphic(Width:Int, Height:Int, Color:FlxColor = FlxColor.WHITE, Unique:Bool = false, ?Key:String) {
		var graph:flixel.graphics.FlxGraphic = FlxG.bitmap.create(Width, Height, Color, Unique, Key);
		frames = graph.imageFrame;
		return this;
	}

	public function center(axes:flixel.util.FlxAxes = XY):BGSprite {
		if (axes.x || axes.y) axes.x ? x = (FlxG.width - width) / 2 : y = (FlxG.height - height) / 2;
		return this;
	}
}