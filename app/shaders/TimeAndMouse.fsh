//TimeAndMouse.fsh

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
varying vec2 qt_TexCoord0;
uniform float mouseXPos;
uniform float mouseYPos;

vec3 colorA = vec3(0.149,0.141,0.912);
vec3 colorB = vec3(1.000,0.833,0.224);

void main() {
    vec3 color = vec3(0.0);

    float pct = abs(sin(u_time));

    // Mix uses pct (a value from 0-1) to
    // mix the two colors
	if (mouseXPos >= qt_TexCoord0.s - 0.1 && mouseXPos <= qt_TexCoord0.s + 0.1 && mouseYPos >= qt_TexCoord0.t - 0.1 && mouseYPos <= qt_TexCoord0.t + 0.1)
color = vec3(1.0, 0.0, 0.0);
else
    color = mix(colorA, colorB, pct);

    gl_FragColor = vec4(color,1.0);
}

