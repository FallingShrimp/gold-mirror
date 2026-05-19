shader_type canvas_item;

uniform vec3 gold_color : source_color = vec3(1.0, 0.84, 0.0);
uniform float star_size : hint_range(0.1, 2.0) = 0.8;

// 尖四角星SDF（菱形交叉）
float sharp_four_star(vec2 p, float size) {
    p = abs(p);
    // 主对角线方向（大角）
    float d1 = (p.x + p.y) * 0.7071;
    // 副对角线方向（小角）  
    float d2 = max(p.x, p.y);
    
    // 混合比例：大角更突出
    float d = mix(d1, d2, 0.35);
    return d - size * 0.5;
}

void fragment() {
    vec2 uv = (UV - 0.5) * 2.0;
    
    // 计算星星距离场
    float dist = sharp_four_star(uv, star_size);
    
    // 抗锯齿边缘
    float alpha = 1.0 - smoothstep(-0.005, 0.005, dist);
    
    // 简单的中心到边缘变暗（增加立体感）
    float center = 1.0 - length(uv) * 0.5;
    center = clamp(center, 0.6, 1.0);
    
    vec3 color = gold_color * center;
    
    COLOR = vec4(color, alpha);
}