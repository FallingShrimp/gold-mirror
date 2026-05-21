shader_type canvas_item;

// 由 y=k/x 和 y=-k/x 围成的闪金光四角星
// 使用方法: 赋给 ColorRect 或 Sprite2D 的 material

uniform float k : hint_range(0.05, 2.0) = 0.3;           // 双曲线参数 k，控制角的尖锐度和大小
uniform float star_size : hint_range(0.1, 1.5) = 1.0;     // 整体缩放
uniform float glow_intensity : hint_range(0.0, 3.0) = 1.5;
uniform float glow_radius : hint_range(0.5, 4.0) = 2.0;
uniform vec4 star_color : source_color = vec4(1.0, 0.85, 0.1, 1.0);   // 主金色
uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);    // 橙金光晕
uniform float rotation : hint_range(0.0, 6.283) = 0.0;   // 旋转角度 (弧度)

// 计算点到双曲线 y = k/x 的符号距离
// 双曲线方程: xy - k = 0
// 梯度: (y, x)，法向距离 = (xy - k) / sqrt(x^2 + y^2)
float sdHyperbola(vec2 p, float k_val) {
    return (p.x * p.y - k_val) / length(p);
}

// 计算点到双曲线 y = -k/x 的符号距离
// 方程: xy + k = 0
float sdHyperbolaNeg(vec2 p, float k_val) {
    return (p.x * p.y + k_val) / length(p);
}

// 判断点是否在双曲线围成的星形区域内
// 第一象限: 在 y=k/x 下方 且 在 y=-k/x 上方 -> xy < k 且 xy > -k
// 实际上四个象限的星形区域由 |xy| < k 定义
float sdStarHyperbola(vec2 p, float k_val) {
    // 旋转
    float c = cos(rotation);
    float s = sin(rotation);
    p = vec2(c * p.x - s * p.y, s * p.x + c * p.y);

    // 星形区域: |xy| < k，边界是 |xy| = k
    // 到边界 |xy| = k 的距离
    float f = abs(p.x * p.y);
    float dist_to_boundary = (f - k_val) / length(p);

    return dist_to_boundary;
}

void fragment() {
    // UV 转换到中心，范围约 [-0.5, 0.5]
    vec2 uv = UV - vec2(0.5);

    // 应用缩放，保持宽高比
    float scale = star_size * 0.6;
    uv /= scale;

    // 计算 SDF
    float d = sdStarHyperbola(uv, k);

    // 星星本体 (硬边缘)
    float star_alpha = 1.0 - smoothstep(0.0, 0.008, d);

    // 外发光
    float glow = 1.0 - smoothstep(0.0, 0.15 * glow_radius, d);
    glow = pow(glow, 1.8);

    // 中心高光
    float highlight = 1.0 - smoothstep(0.0, 0.08, max(d, 0.0));
    highlight = pow(highlight, 3.0);

    // 边缘金属闪耀
    float sparkle = pow(1.0 - smoothstep(0.0, 0.02, abs(d)), 5.0);

    // 组合颜色
    vec4 col = vec4(0.0);

    // 光晕底色
    col += glow_color * glow * glow_intensity * 0.4;

    // 星星本体
    col += star_color * star_alpha;

    // 中心高光 (白金色)
    col += vec4(1.0, 0.95, 0.75, 1.0) * highlight * 0.8;

    // 边缘闪耀
    col += vec4(1.0, 0.9, 0.6, 1.0) * sparkle * 0.5;

    COLOR = col;
    COLOR.a = clamp(col.a, 0.0, 1.0);
}