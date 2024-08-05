package shaders;

class SkewShader extends flixel.system.FlxAssets.FlxShader {
	@:glFragmentSource("
	#pragma header

	uniform float shit;

	void main()
	{
    	vec2 uv = (openfl_TextureCoordv)*2. - 0.5;
	    vec2 uvR = uv;

	    uv *= mat2(1.0, shit, 0.0, 1.0);
    	uv.y += 0.5;
		vec4 col = flixel_texture2D(bitmap, uv);
      
		if (uv.x <= 0.0 || uv.x > 1.0 || uv.y <= 0.0 || uv.y > 1.0) col = vec4(0.0);

    	gl_FragColor = col;
	}")
	public function new() {
		super();
		shit.value = [0.0];
	}
}