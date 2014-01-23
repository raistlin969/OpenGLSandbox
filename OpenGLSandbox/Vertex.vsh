#extension GL_EXT_separate_shader_objects : enable

layout(location = 0)attribute vec4 position;

//out gl_PerVertex
//{
//    vec4 gl_Position;
//};

void main()
{
    gl_Position = position;
}

