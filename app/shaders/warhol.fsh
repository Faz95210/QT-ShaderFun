//warhol.fsh
uniform float dividerValue;
uniform sampler2D source;
uniform lowp float qt_Opacity;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec4 orig = texture2D(source, uv);
    vec3 col = orig.rgb;
    float y = 0.3 *col.r + 0.59 * col.g + 0.11 * col.b;
    y = y < 0.3 ? 0.0 : (y < 0.6 ? 0.5 : 1.0);
    if (y == 0.5)
        col = vec3(0.0, 0.0, 0.8);
    else if (y == 1.0)
        col = vec3(0.0, 0.9, 0.9);
    else
        col = vec3(0.0, 0.0, 0.0);
    if (uv.x < dividerValue)
        gl_FragColor = qt_Opacity * vec4(col, 1.0);
    else
        gl_FragColor = qt_Opacity * orig;
}
