shader_type canvas_item;

uniform bool use_grayscale = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (use_grayscale) {
        float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
        COLOR = vec4(vec3(gray), tex_color.a);
    } else {
        COLOR = tex_color;
    }
}
