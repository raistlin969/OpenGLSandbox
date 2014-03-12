#extension GL_EXT_separate_shader_objects : enable

layout(location = 0)attribute vec4 position;
layout(location = 1)attribute vec2 a_virtualXY;

varying mediump vec2 v_virtualXY;

void main()
{
    v_virtualXY = a_virtualXY;
    gl_Position = position;
}
