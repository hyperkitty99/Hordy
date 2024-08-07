package shaders;

import flixel.system.FlxAssets;

class NTSCShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header

    #pragma format R8G8B8A8_SRGB

    #define NTSC_CRT_GAMMA 2.5
    #define NTSC_MONITOR_GAMMA 2.0

    #define TWO_PHASE
    #define COMPOSITE
    //#define THREE_PHASE
    // #define SVIDEO

    // begin params
    #define PI 3.14159265

    #if defined(TWO_PHASE)
        #define CHROMA_MOD_FREQ (4.0 * PI / 15.0)
    #elif defined(THREE_PHASE)
        #define CHROMA_MOD_FREQ (PI / 3.0)
    #endif

    #if defined(COMPOSITE)
        #define SATURATION 1.0
        #define BRIGHTNESS 1.0
        #define ARTIFACTING 1.0
        #define FRINGING 1.0
    #elif defined(SVIDEO)
        #define SATURATION 1.0
        #define BRIGHTNESS 1.0
        #define ARTIFACTING 0.0
        #define FRINGING 0.0
    #endif
    // end params

    uniform int uFrame;
    uniform float uInterlace;

    // fragment compatibility #defines

    #if defined(COMPOSITE) || defined(SVIDEO)
    mat3 mix_mat = mat3(
        BRIGHTNESS, FRINGING, FRINGING,
        ARTIFACTING, 2.0 * SATURATION, 0.0,
        ARTIFACTING, 0.0, 2.0 * SATURATION
    );
    #endif

    // begin ntsc-rgbyuv
    const mat3 yiq2rgb_mat = mat3(
        1.0, 0.956, 0.6210,
        1.0, -0.2720, -0.6474,
        1.0, -1.1060, 1.7046);

    vec3 yiq2rgb(vec3 yiq)
    {
        return yiq * yiq2rgb_mat;
    }

    const mat3 yiq_mat = mat3(
        0.2989, 0.5870, 0.1140,
        0.5959, -0.2744, -0.3216,
        0.2115, -0.5229, 0.3114
    );

    vec3 rgb2yiq(vec3 col)
    {
        return col * yiq_mat;
    }
    // end ntsc-rgbyuv

    #define TAPS 32

    float luma_filter(int i) {
        if (i == 0) return -0.000174844;
        if (i == 1) return -0.000205844;
        if (i == 2) return -0.000149453;
        if (i == 3) return -0.000051693;
        if (i == 4) return 0.000000000;
        if (i == 5) return -0.000066171;
        if (i == 6) return -0.000245058;
        if (i == 7) return -0.000432928;
        if (i == 8) return -0.000472644;
        if (i == 9) return -0.000252236;
        if (i == 10) return 0.000198929;
        if (i == 11) return 0.000687058;
        if (i == 12) return 0.000944112;
        if (i == 13) return 0.000803467;
        if (i == 14) return 0.000363199;
        if (i == 15) return 0.000013422;
        if (i == 16) return 0.000253402;
        if (i == 17) return 0.001339461;
        if (i == 18) return 0.002932972;
        if (i == 19) return 0.003983485;
        if (i == 20) return 0.003026683;
        if (i == 21) return -0.001102056;
        if (i == 22) return -0.008373026;
        if (i == 23) return -0.016897700;
        if (i == 24) return -0.022914480;
        if (i == 25) return -0.021642347;
        if (i == 26) return -0.008863273;
        if (i == 27) return 0.017271957;
        if (i == 28) return 0.054921920;
        if (i == 29) return 0.098342579;
        if (i == 30) return 0.139044281;
        if (i == 31) return 0.168055832;
        if (i == 32) return 0.178571429;
        return 0.0;
    }

    float chroma_filter(int i) {
        if (i == 0) return 0.001384762;
        if (i == 1) return 0.001678312;
        if (i == 2) return 0.002021715;
        if (i == 3) return 0.002420562;
        if (i == 4) return 0.002880460;
        if (i == 5) return 0.003406879;
        if (i == 6) return 0.004004985;
        if (i == 7) return 0.004679445;
        if (i == 8) return 0.005434218;
        if (i == 9) return 0.006272332;
        if (i == 10) return 0.007195654;
        if (i == 11) return 0.008204665;
        if (i == 12) return 0.009298238;
        if (i == 13) return 0.010473450;
        if (i == 14) return 0.011725413;
        if (i == 15) return 0.013047155;
        if (i == 16) return 0.014429548;
        if (i == 17) return 0.015861306;
        if (i == 18) return 0.017329037;
        if (i == 19) return 0.018817382;
        if (i == 20) return 0.020309220;
        if (i == 21) return 0.021785952;
        if (i == 22) return 0.023227857;
        if (i == 23) return 0.024614500;
        if (i == 24) return 0.025925203;
        if (i == 25) return 0.027139546;
        if (i == 26) return 0.028237893;
        if (i == 27) return 0.029201910;
        if (i == 28) return 0.030015081;
        if (i == 29) return 0.030663170;
        if (i == 30) return 0.031134640;
        if (i == 31) return 0.031420995;
        if (i == 32) return 0.031517031;
        return 0.0;
    }

    vec4 pass1(vec2 uv)
    {
        vec2 fragCoord = uv * openfl_TextureSize;

        vec4 cola = texture2D(bitmap, uv).rgba;
        vec3 yiq = rgb2yiq(cola.rgb);

        #if defined(TWO_PHASE)
            float chroma_phase = PI * (mod(fragCoord.y, 2.0) + float(uFrame));
        #elif defined(THREE_PHASE)
            float chroma_phase = 0.6667 * PI * (mod(fragCoord.y, 3.0) + float(uFrame));
        #endif

        float mod_phase = chroma_phase + fragCoord.x * CHROMA_MOD_FREQ;

        float i_mod = cos(mod_phase);
        float q_mod = sin(mod_phase);

        if(uInterlace == 1.0) {
            yiq.yz *= vec2(i_mod, q_mod); // Modulate.
            yiq *= mix_mat; // Cross-talk.
            yiq.yz *= vec2(i_mod, q_mod); // Demodulate.
        }
        return vec4(yiq, cola.a);
    }

    vec4 fetch_offset(vec2 uv, float offset, float one_x) {
        return pass1(uv + vec2((offset - 0.5) * one_x, 0.0)).xyzw;
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        vec2 fragCoord = uv * openfl_TextureSize;

        float one_x = 1.0 / openfl_TextureSize.x;
        vec4 signal = vec4(0.0);

        for (int i = 0; i < TAPS; i++)
        {
            float offset = float(i);

            vec4 sums = fetch_offset(uv, offset - float(TAPS), one_x) * 2;

            signal += sums * vec4(luma_filter(i), chroma_filter(i), chroma_filter(i), 1.0);
        }
        signal += pass1(uv - vec2(0.5 / openfl_TextureSize.x, 0.0)).xyzw *
            vec4(luma_filter(TAPS), chroma_filter(TAPS), chroma_filter(TAPS), 1.0);

        vec3 rgb = yiq2rgb(signal.xyz);
        gl_FragColor = vec4(pow(rgb, vec3(NTSC_CRT_GAMMA / NTSC_MONITOR_GAMMA)), flixel_texture2D(bitmap, uv).a);
    }
    ')
    public function new()
    {
        super();
        uFrame.value = [0];
        uInterlace.value = [1.0];
    }
}