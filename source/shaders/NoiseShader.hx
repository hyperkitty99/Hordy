package shaders;

class NoiseEffect {
    public var shader:NoiseShader = new NoiseShader();

    @:isVar public var time(get, set):Float = 0;

    function get_time() return shader.iTime.value[0];
    function set_time(val:Float) return shader.iTime.value[0] = val;
    
    public function new() {shader.iTime.value[0] = 0;}
}

class NoiseShader extends flixel.system.FlxAssets.FlxShader {
    @:glFragmentSource('
    #pragma header

    uniform float iTime;

    vec3 mod289(vec3 x) {
        return x - floor(x * (1.0 / 289.0)) * 289.0;
    }

    vec2 mod289(vec2 x) {
        return x - floor(x * (1.0 / 289.0)) * 289.0;
    }

    vec3 permute(vec3 x) {
        return mod289(((x*34.0)+1.0)*x);
    }

    float hash3(vec3 p) {
        return fract(sin(1e3*dot(p,vec3(1,57,-13.7)))*4375.5453);
    }

    float noise3(vec3 x, out vec2 g) {
        vec3 p = floor(x);
        vec3 f = fract(x);
        vec3 F = f*f*(3.0-2.0*f);

        float v000 = hash3(p+vec3(0,0,0));
        float v100 = hash3(p+vec3(1,0,0));
        float v010 = hash3(p+vec3(0,1,0));
        float v110 = hash3(p+vec3(1,1,0));
        float v001 = hash3(p+vec3(0,0,1));
        float v101 = hash3(p+vec3(1,0,1));
        float v011 = hash3(p+vec3(0,1,1));
        float v111 = hash3(p+vec3(1,1,1));
    
        g.x = 6.0*f.x*(1.0-f.x) * mix(
            mix(v100 - v000, v110 - v010, F.y),
            mix(v101 - v001, v111 - v011, F.y),
            F.z
        );
        g.y = 6.0*f.y*(1.0-f.y) * mix(
            mix(v010 - v000, v110 - v100, F.x),
            mix(v011 - v001, v111 - v101, F.x),
            F.z
        );
    
        return mix(
            mix(mix(v000, v100, F.x), mix(v010, v110, F.x), F.y),
            mix(mix(v001, v101, F.x), mix(v011, v111, F.x), F.y),
            F.z
        );
    }

    float noise(vec3 x, out vec2 g) {
        vec2 g0, g1;
        float n = (noise3(x, g0) + noise3(x+11.5, g1)) / 2.0;
        g = (g0+g1) / 2.0;
        return n;
    }

    void main() {
        vec2 uv = openfl_TextureCoordv;
        vec2 R = openfl_TextureSize;
        vec2 U = uv * R * 8.0 / R.y;

        vec2 g;
        float n = noise(vec3(U, 0.1 * iTime), g);
        float v = sin(6.28 * 10.0 * n);

        g *= 6.28 * 10.0 * cos(6.28 * 10.0 * n) * 8.0 / R.y;
        float d = (abs(g.x) + abs(g.y));
        v = tanh(min(2.0 * abs(v) / d, 10.0));
        n = floor(n * 20.0) / 20.0;

        vec4 O = v * mix(vec4(1), 0.5 + 0.5 * cos(12.0 * n + vec4(0, 2.1, -2.1, 0)), 1.0);

        float n2 = noise(vec3(U + 0.05, 0.1 * iTime), g);
        g *= 6.28 * 10.0 * cos(6.28 * 10.0 * n) * 8.0 / R.y;
        d = (abs(g.x) + abs(g.y));
        if (n > n2) O *= exp(-(n - n2) / d * 13.0 * pow(1e3 / R.y, 1.5));

        O.a = 1.0;

        vec4 texColor = flixel_texture2D(bitmap, uv);
        gl_FragColor = O * texColor;
    }
    ')
    public function new() {
        super();
        iTime.value = [0.0];
    }
}