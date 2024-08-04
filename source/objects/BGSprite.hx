package objects;

class BGSprite extends FlxSprite {
	private var idleAnim:String;
	public function new(image:String, x:Float = 0, y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1, ?animArray:Array<String> = null, ?loop:Bool = false) {
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
	}

	public function dance(?forceplay:Bool = false):Void if (idleAnim != null) animation.play(idleAnim, forceplay);
}