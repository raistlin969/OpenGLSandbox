#extension GL_EXT_separate_shader_objects : enable

layout(location = 0)attribute vec4 position;
layout(location = 1)attribute vec2 a_virtualXY;

varying mediump vec2 v_virtualXY;

void main()
{
    v_virtualXY = 3.1415926 * (2.0 * a_virtualXY) - 3.1415926;
    gl_Position = position;
}
