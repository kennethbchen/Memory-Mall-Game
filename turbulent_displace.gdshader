shader_type spatial;
render_mode unshaded;

// https://www.shadertoy.com/view/MscSzf

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform sampler2D NOISE_PATTERN;

uniform float noise_amount = 0.01;
uniform float error_range = 0.001;
uniform float error_period = 0.1;

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	
	vec2 uv = SCREEN_UV;
	
	float noise = texture(NOISE_PATTERN, uv).r * noise_amount;
	
	uv = uv + vec2(error_range * sin(error_period * uv.y) + noise, error_range * sin(error_period * uv.x) + noise);
	
	vec4 screen_color = textureLod(SCREEN_TEXTURE, uv, 0.0);
	
	ALBEDO = screen_color.rgb;
	
}
