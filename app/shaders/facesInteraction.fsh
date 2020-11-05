//facesInteraction.fsh

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D source;
varying vec2    qt_TexCoord0;

uniform int   face_count;
uniform float   face_x;
uniform float   face_y;
uniform float   face_width;
uniform float   face_height;


void main() {
    if (face_x == -1.0){
        gl_FragColor.rgba = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }
    if (qt_TexCoord0.t >= face_x - (face_width) && qt_TexCoord0.t <= face_x + (face_width)
        && qt_TexCoord0.s >= face_y  && qt_TexCoord0.s <= face_y + (face_height)) {
                   gl_FragColor.rgba = texture2D(source, qt_TexCoord0).rgba;
    } else {
           gl_FragColor.rgba = texture2D(source, vec2(face_x, qt_TexCoord0.s)).rgba;

    }
}

