shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec3 outline_color: source_color = vec3(0.0);
uniform float outline_thickness = 2;

void vertex() {
	VERTEX = VERTEX + NORMAL * outline_thickness;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
