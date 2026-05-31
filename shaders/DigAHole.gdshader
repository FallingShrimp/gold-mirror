shader_type canvas_item;
uniform vec2 focus_center=vec2(960.0, 540.0);
uniform float radius : hint_range(0.0, 1000.0) = 100.0;
void fragment() {
    vec2 rect_size = vec2(1.0) / TEXTURE_PIXEL_SIZE;
    vec2 pixel_pos = UV * rect_size;
    vec2 diff = pixel_pos - focus_center;
    diff.x *= rect_size.y / rect_size.x;
    float dist = length(diff);
    float alpha = step(radius, dist) * 0.5;
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}