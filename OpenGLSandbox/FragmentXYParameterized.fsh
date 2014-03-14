uniform sampler2D s_texture;
varying mediump vec2 v_virtualXY;

void main()
{
    gl_FragColor = texture2D(s_texture, v_virtualXY);
//    gl_FragColor = vec4(s_texture.x, 0.0, s_texture.y, 1.0);
}