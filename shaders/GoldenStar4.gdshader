shader_type canvas_item;
uniform float k : hint_range(0.05, 2.0) = 0.3;
uniform float star_size : hint_range(0.1, 1.5) = 1.0;
uniform float glow_intensity : hint_range(0.0, 3.0) = 1.5;
uniform float glow_radius : hint_range(0.5, 10.0) = 2.0;
uniform vec4 star_color : source_color = vec4(1.0, 0.85, 0.1, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float rotation : hint_range(0.0, 6.283) = 0.0;
float sdHyperbola(vec2 p, float k_val) {
    return (p.x * p.y - k_val) / length(p);
}
float sdHyperbolaNeg(vec2 p, float k_val) {
    return (p.x * p.y + k_val) / length(p);
}
float sdStarHyperbola(vec2 p, float k_val) {
    float c = cos(rotation);
    float s = sin(rotation);
    p = vec2(c * p.x - s * p.y, s * p.x + c * p.y);
    float f = abs(p.x * p.y);
    float dist_to_boundary = (f - k_val) / length(p);
    return dist_to_boundary;
}
void fragment() {
    vec2 uv = UV - vec2(0.5);
    float scale = star_size * 0.6;
    uv /= scale;
    float d = sdStarHyperbola(uv, k);
    float star_alpha = 1.0 - smoothstep(0.0, 0.008, d);
    float glow = 1.0 - smoothstep(0.0, 0.15 * glow_radius, d);
    glow = pow(glow, 1.8);
    float highlight = 1.0 - smoothstep(0.0, 0.08, max(d, 0.0));
    highlight = pow(highlight, 3.0);
    float sparkle = pow(1.0 - smoothstep(0.0, 0.02, abs(d)), 5.0);
    vec4 col = vec4(0.0);
    col += glow_color * glow * glow_intensity * 0.4;
    col += star_color * star_alpha;
    col += vec4(1.0, 0.95, 0.75, 1.0) * highlight * 0.8;
    col += vec4(1.0, 0.9, 0.6, 1.0) * sparkle * 0.5;
    COLOR = col;
    COLOR.a = clamp(col.a, 0.0, 1.0);
}
