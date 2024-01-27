shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled;

uniform vec3 outline_color: source_color = vec3(0.0);

uniform float noise_sensitivity = 0.05;
uniform float noise_range = 0.75;
uniform sampler2D NOISE_TEXTURE;

// Requires smooth shading on meshes

void vertex() {
	
	vec3 clip_space_pos = ((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)) * PROJECTION_MATRIX).xyz;
	float noise_val = (texture(NOISE_TEXTURE, (((clip_space_pos.xy + clip_space_pos.z / 2.0) + (TIME / 2.0))* noise_sensitivity)).rgb).r ;
	VERTEX = VERTEX - NORMAL * (noise_range * sin(noise_val));
}

void fragment() {
	ALBEDO = outline_color;
}



