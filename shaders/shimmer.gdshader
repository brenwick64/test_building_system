shader_type canvas_item;

uniform bool glow_enabled = false; // Still acts as hard toggle (skip loops when false)
uniform float glow_blend : hint_range(0.0, 1.0) = 1.0; // Fade-in/out factor
uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.2, 1.0); // Glow tint
uniform float glow_size : hint_range(0.0, 20.0) = 6.0;  // Thickness of glow
uniform float glow_strength : hint_range(0.0, 5.0) = 1.5; // Brightness
uniform float shimmer_speed : hint_range(0.0, 10.0) = 2.0; // Shimmer speed
uniform float shimmer_intensity : hint_range(0.0, 1.0) = 0.3; // Shimmer amount

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 final_color = tex;

    if (glow_enabled && glow_blend > 0.0) {
        float dist = 0.0;

        // Sample in a circle around pixel to find transparency (edge detection)
        for (float a = 0.0; a < 6.28318; a += 0.785398) { // 8 directions
            for (float r = 1.0; r <= glow_size; r++) {
                vec2 offset = vec2(cos(a), sin(a)) * r * TEXTURE_PIXEL_SIZE;
                if (texture(TEXTURE, UV + offset).a < 0.1) {
                    dist = r;
                    break;
                }
            }
            if (dist > 0.0) break;
        }

        float glow_factor = 1.0 - clamp(dist / glow_size, 0.0, 1.0);
        float shimmer = 1.0 + sin(TIME * shimmer_speed + UV.x * 5.0 + UV.y * 5.0) * shimmer_intensity;

        if (dist > 0.0 && tex.a < 0.1) { // Only outside sprite
            final_color.rgb = glow_color.rgb * glow_factor * glow_strength * shimmer * glow_blend;
            final_color.a = glow_factor * glow_color.a * glow_blend;
        }
    }

    COLOR = final_color;
}