shader_type spatial;
render_mode unshaded, cull_front, shadows_disabled, ambient_light_disabled;

uniform vec3 outline_color: source_color = vec3(0.0);
uniform float outline_thickness = 0.25;

void vertex() {
	VERTEX = VERTEX + NORMAL * outline_thickness;
}

void fragment() {
	ALBEDO = outline_color;
}



