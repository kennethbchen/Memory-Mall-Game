shader_type spatial;
render_mode unshaded, cull_disabled, depth_prepass_alpha;

uniform float w1_range = 0.2;
uniform float w2_range = 0.1;

uniform vec4 wavy_color: source_color = vec4(0., .8, 1.0, 1.0);

uniform int w1_spikes: hint_range(0, 20) = 10;
uniform int w2_spikes: hint_range(0, 40) = 5;

uniform float speed = 4.0;

uniform float sharpness: hint_range(0.0, 0.99) = 0.5;

uniform float offset = 0.4;

void fragment() {
	
	vec2 uv = UV;
	uv.y *= 2.0;
    float w1 = uv.y + w1_range * cos(uv.x * float(w1_spikes) * TAU + TIME * speed) + offset;
	w1 = smoothstep(0.5, 1.0, w1);
    float w2 = uv.y + w2_range * cos(uv.x * float(w2_spikes) * TAU + TIME * speed) + offset;
	w2 = smoothstep(0.2, 1.0, w2);
    
    float m = (w1 + w2);
    
    float mask = smoothstep(sharpness, 1.0, m);
    vec4 color = mix(vec4(0.0), wavy_color, mask);
    
    ALBEDO = color.rgb;
	ALPHA = color.a;
}