uniform sampler2D s_texture;
varying mediump vec2 v_virtualXY;

void main()
{
//    gl_FragColor = texture2D(s_texture, v_virtualXY);
    highp vec2 c = texture2D(s_texture, v_virtualXY).xy;
    highp vec2 z = c;
    gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
    for(mediump float i = 0.0; i < 256.0; i += 1.0)
    {
        z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
        if(dot(z,z) > 4.0)
        {
            gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
            break;
        }
    }
}