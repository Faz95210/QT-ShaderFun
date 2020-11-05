//split.fsh
//precision mediump float;

uniform sampler2D source;
varying vec2 qt_TexCoord0;
uniform float dividerValue;
uniform lowp float qt_Opacity;

void warholit(vec2 off, bool r, bool g, bool b) {
    vec4 orig = texture2D(source, off); // Get RGBA from the source with off as offset
    vec3 col = orig.rgb; // Get RGB From orig
    float y = 0.3 *col.r + 0.59 * col.g + 0.11 * col.b;
    y = y < 0.3 ? 0.0 : (y < 0.6 ? 0.5 : 1.0);
    if (y == 0.5)
        col = vec3(r ? 0.8 : 0.0, g ? 0.8 : 0.0, b ? 0.8 : 0.0);
    else if (y == 1.0)
        col = vec3(r ? 0.9 : 0.0, g ? 0.9 : 0.0, b ? 0.9 : 0.0);
    else
        col = vec3(r ? 0.0 : 0.5, g ? 0.0 : 0.5,  b ? 0.0 : 0.5);
    if (off.x < dividerValue)
        gl_FragColor = qt_Opacity * vec4(col, 1.0);
    else
        gl_FragColor = qt_Opacity * orig;
}

void main(void)
{
    vec2 off = qt_TexCoord0;
    if (off.s > 0.5 && off.t > 0.5){ // BOTTOM RIGHT
        off.s -= 0.3;
        off.t -= 0.3;
        warholit(off, true, false, false);
    } else if (off.s < 0.5 && off.t > 0.5){ // BOTTOM LEFT
        off.s += 0.3;
        off.t -= 0.3;
        warholit(off, false, false, true);
    } else if (off.s > 0.5 && off.t < 0.5){ // TOP RIGHT
        off.s -= 0.3;
        off.t += 0.3;
        warholit(off, false, true, false);
    } else if (off.s < 0.5 && off.t < 0.5){ // TOP LEFT
        off.s += 0.3;
        off.t += 0.3;
        warholit(off, false, true, true);
    }
}
