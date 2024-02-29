shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float wiggle_speed = 1;
uniform vec2 wiggle_period = vec2(11.0);
uniform vec2 wiggle_range = vec2(0.007);
uniform float noise_strength = 0.5;
uniform sampler2D NOISE_TEXTURE;

void fragment() {
	
	vec2 uv = UV;
	
	// Distort the uv coordinate for a wavy effect
	float noise = texture(NOISE_TEXTURE, uv).r * noise_strength;
	uv.x += wiggle_range.x * sin(UV.y * wiggle_period.x + TIME * wiggle_speed + noise);
	uv.y += wiggle_range.y * cos(UV.x * wiggle_period.y + TIME * wiggle_speed + noise);
	
	//COLOR = vec4(uv.xy, 0.0, 1.0);
	COLOR = texture(screen_texture, uv);

}

