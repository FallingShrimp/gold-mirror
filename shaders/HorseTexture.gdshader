shader_type canvas_item;
uniform vec4 dark_red : source_color = vec4(0.545, 0.0, 0.0, 1.0);
uniform vec4 light_red : source_color = vec4(1.0, 0.388, 0.278, 1.0);
uniform float stripe_count : hint_range(1.0, 100.0) = 10.0;
uniform float speed : hint_range(-5.0, 5.0) = 1.0;
uniform float angle_degrees : hint_range(0.0, 360.0) = 45.0;
void fragment() {
    float angle_rad = radians(angle_degrees);
    vec2 uv = UV;
    float projected = uv.x * cos(angle_rad) + uv.y * sin(angle_rad);
    float moving_pos = projected + TIME * speed;
    float stripe_width = 1.0 / stripe_count;
    float stripe_index = floor(moving_pos / stripe_width);
    if (mod(stripe_index, 2.0) < 0.5) {
        COLOR = dark_red;
    } else {
        COLOR = light_red;
    }
}