package objects;

class FlxPenis extends flixel.addons.effects.FlxSkewedSprite {
	public function new(?image:String, ?X:Float = 0, ?Y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1) {
		super(X, Y);

		loadGraphic(Paths.image(image));
        scrollFactor.set(scrollX, scrollY);
		updateHitbox();
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		skew.x = -(FlxG.camera.scroll.x - x - width) / 350;
		scale.y = -(FlxG.camera.scroll.y - y - height) / 800;
	}

	override public function isOnScreen(?camera:flixel.FlxCamera):Bool return true;
}