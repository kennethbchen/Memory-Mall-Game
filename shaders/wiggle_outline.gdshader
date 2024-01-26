shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled;

uniform vec3 outline_color: source_color = vec3(0.0);

uniform float noise_amount = 1.0;
uniform float error_range = 0.25;
uniform sampler2D NOISE_TEXTURE;

// Requires smooth shading on meshes

void vertex() {
	
	vec3 clip_space_pos = ((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)) * PROJECTION_MATRIX).xyz;
	float noise_val = (texture(NOISE_TEXTURE, ((clip_space_pos.xy + clip_space_pos.z) * 0.1) + sin(TIME / 10.0)).rgb).r * noise_amount;
	VERTEX = VERTEX - NORMAL * (error_range * sin(noise_val));
	//VERTEX.x = VERTEX.x - NORMAL.x * (error_range * sin(noise_val));
	//VERTEX.y = VERTEX.y - NORMAL.y * (error_range * sin(noise_val));
	//VERTEX.z = VERTEX.z - NORMAL.z * (error_range * sin(noise_val));
}

void fragment() {
	ALBEDO = outline_color;
}



