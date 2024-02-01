shader_type canvas_item;

uniform float wiggle_speed = 1;
uniform float wiggle_period = 11.0;
uniform float wiggle_range = 0.007;
uniform float noise_strength = 0.5;
uniform sampler2D NOISE_TEXTURE;

void fragment() {
	
	vec2 uv = UV;
	
	// Distort the uv coordinate for a wavy effect
	float noise = texture(NOISE_TEXTURE, uv).r * noise_strength;
	uv.x += wiggle_range * sin(UV.y * wiggle_period + TIME * wiggle_speed + noise);
	uv.y += wiggle_range * cos(UV.x * wiggle_period + TIME * wiggle_speed + noise) ;
	
	//COLOR = vec4(uv.xy, 0.0, 1.0);
	COLOR = texture(TEXTURE, uv);

}

