package debug;

import flixel.FlxG;

import openfl.text.TextField;

class FPSCounter extends TextField {
	public var currentFPS(default, null):Int = 0;
	public var memoryMegas(get, never):Float;
	public var tColor:Int;

	@:noCompletion private var times:Array<Float>;

	public function new(?color:Int = 0xFFFFFFFF) {
		super();

		this.x = this.y = 10;

		tColor = color;
		selectable = false;
		mouseEnabled = false;
		multiline = true;
		defaultTextFormat = new openfl.text.TextFormat(openfl.utils.Assets.getFont("assets/fonts/FallingSkyBlk.otf").fontName, 14, tColor, null, null, null, null, null, RIGHT);

		times = [];
	}

	var deltaTimeout:Float = 0.0;
	private override function __enterFrame(deltaTime:Float):Void {
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout += deltaTime;
	}
	
	function updateText():Void {
		text = '${currentFPS}  :FPS'+ '\n${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}  :Memory';
		width = openfl.Lib.application.window.width - x * 2;

		textColor = tColor;
		if (currentFPS < FlxG.drawFramerate * 0.5) textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float return cast(openfl.system.System.totalMemory, UInt);
}