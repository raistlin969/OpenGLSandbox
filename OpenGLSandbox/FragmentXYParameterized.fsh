varying mediump vec2 v_virtualXY;

void main()
{
    mediump float red, green, blue;
    red = green = blue = sin(v_virtualXY.x) + sin(v_virtualXY.y);
    blue *= cos(v_virtualXY.y);
    gl_FragColor = vec4(red, green, blue, 1.0);
}