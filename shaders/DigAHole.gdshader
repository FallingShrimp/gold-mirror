shader_type canvas_item;

uniform vec2 focus_center=vec2(960.0, 540.0);
uniform float radius : hint_range(0.0, 1000.0) = 100.0;

void fragment() {
    // ColorRect 的实际像素尺寸
    vec2 rect_size = vec2(1.0) / TEXTURE_PIXEL_SIZE;
    
    // UV 转像素坐标，x 轴按宽高比修正
    vec2 pixel_pos = UV * rect_size;
    
    // 计算距离：把 x 差值按 (高度/宽度) 缩放，让圆在视觉上保持正圆
    vec2 diff = pixel_pos - focus_center;
    diff.x *= rect_size.y / rect_size.x;  // 修正宽高比
    
    float dist = length(diff);
    float alpha = step(radius, dist) * 0.5;
    
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}