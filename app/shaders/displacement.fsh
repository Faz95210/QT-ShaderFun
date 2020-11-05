//displacement.fsh

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main(void)
{
    vec2 uv = qt_TexCoord0.xy;
    vec4 c = texture2D(source, uv);
    c.rgb = sin(c.rgb*(6.2)
                +vec3(3., 1.5,.5 * texture2D(source, vec2(1.5*length(uv-.5),1.)).r))
            *.5+.5;
    gl_FragColor = c;
}
