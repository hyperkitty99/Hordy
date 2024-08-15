package shaders;

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
		strength.value = [0.0];
        darkness.value = [0.0];
	}
}