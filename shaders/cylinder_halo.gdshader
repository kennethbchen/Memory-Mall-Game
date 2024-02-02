shader_type spatial;
render_mode unshaded, cull_disabled, depth_prepass_alpha;

uniform float w1_range = 0.2;
uniform float w2_range = 0.1;

uniform vec4 wavy_color: source_color = vec4(0., .8, 1.0, 1.0);

uniform int w1_spikes: hint_range(0, 20) = 10;
uniform int w2_spikes: hint_range(0, 40) = 5;

uniform float w1_speed = 4.0;

uniform float offset = 0.4;

void fragment() {
	
    float w1 = UV.y + w1_range * cos(UV.x * float(w1_spikes) * TAU + TIME * w1_speed);
    float w2 = UV.y + w2_range * cos(UV.x * float(w2_spikes) * TAU);
    
    float m = (w1 + w2) + offset;
    
    float mask = smoothstep(0.0, 1.0, m);
    vec4 color = mix(vec4(0.0), wavy_color, m);
    
    ALBEDO = color.rgb;
	ALPHA = color.a;
}