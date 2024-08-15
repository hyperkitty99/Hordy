package shaders;

class ScaryEffect {
	public var shader:ScaryShader = new ScaryShader();

	@:isVar public var strength(get, set):Float = 1;
	@:isVar public var darkness(get, set):Float = 0;

	function get_strength() return shader.strength.value[0];
	function set_strength(val:Float) return shader.strength.value[0] = val;

	function get_darkness() return shader.darkness.value[0];
	function set_darkness(val:Float) return shader.darkness.value[0] = val;
    
	public function new() {
		shader.strength.value[0] = 1;
		shader.darkness.value[0] = 0;
	}
}

class ScaryShader extends flixel.system.FlxAssets.FlxShader {
    @:glFragmentSource('
    #pragma header

    uniform float strength;
    uniform float darkness;
    void main() {
        vec4 tex = flixel_texture2D(bitmap, openfl_TextureCoordv);
        tex.rgb = ((tex.rgb - 0.5) * max(1.0 * strength, 0.0)) + 0.5;
        tex *= 1.0 -darkness;
        gl_FragColor = tex;
    }')
    public function new() {
        super();
		strength.value = [1.0];
		darkness.value = [0.0];
    }
}