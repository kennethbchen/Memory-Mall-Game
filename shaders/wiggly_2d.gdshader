shader_type canvas_item;

uniform sampler2D BOX_TEXTURE;

uniform float wiggle_speed = 0.5;
uniform float wiggle_period = 1.0;
uniform float wiggle_range = 1.0;

uniform sampler2D NOISE_TEXTURE;

void vertex() {
}

void fragment() {
	
	vec2 uv = UV;
	
	float noise = texture(NOISE_TEXTURE, uv).r;
	uv.x += wiggle_range * sin(uv.y * wiggle_period + TIME * wiggle_speed) + wiggle_range;
	uv.y += wiggle_range * cos(uv.x * wiggle_period + TIME * wiggle_speed) + wiggle_range;
    
	COLOR = texture(BOX_TEXTURE, uv);
	//COLOR = vec4(uv.xy, 0.0, 1.0);
}

