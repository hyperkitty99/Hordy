package shaders;

class BarrelEffect {
	public var shader:BarrelDistortionEffect = new BarrelDistortionEffect();

	@:isVar public var barrelDistortion1(get, set):Float = 0;
	@:isVar public var barrelDistortion2(get, set):Float = 0;

	function get_barrelDistortion1() return shader.dis1.value[0];
	function set_barrelDistortion1(val:Float) return shader.dis1.value[0] = val;

	function get_barrelDistortion2() return shader.dis2.value[0];
	function set_barrelDistortion2(val:Float) return shader.dis2.value[0] = val;
    
	public function new() {
		shader.dis1.value[0]  = 0;
		shader.dis2.value[0] = 0;
	}
}

class BarrelDistortionEffect extends flixel.system.FlxAssets.FlxShader {
    @:glFragmentSource('
    #pragma header
    uniform float dis1;
    uniform float dis2;

    void main() {
        vec2 uv = openfl_TextureCoordv;
        uv -= 0.5;
        uv = uv *= 1.0 + dis1 * (uv.x * uv.x + uv.y * uv.y) + dis2 * (uv.x * uv.x + uv.y * uv.y) * (uv.x * uv.x + uv.y * uv.y);
        uv += 0.5;

        if(uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) gl_FragColor = vec4(0.0);

        gl_FragColor = flixel_texture2D(bitmap, uv);
    }')
    public function new() {
        super();
		dis1.value = [0.0];
		dis2.value = [0.0];
    }
}