//thermalCam.fsh
const bool darkIsHot = true;
varying vec2 qt_TexCoord0;
uniform sampler2D source;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 col = texture2D(source, qt_TexCoord0).bgr;
    float a = col.r;
    if(darkIsHot)
        a = 1.0 - a;
    gl_FragColor.r = 1.0 - clamp(step(0.166, a)*a, 0.0, 0.333) - 0.667*step(0.333, a) + step(0.666, a)*a + step(0.833, a)*1.0;
    gl_FragColor.b = clamp(step(0.333, a)*a, 0.0, 0.5) + step(0.5, a)*0.5;
    gl_FragColor.g = clamp(a, 0.0, 0.166) + 0.834*step(0.166, a) - step(0.5, a)*a - step(0.666, a)*1.0;
}
