shader_type spatial;
render_mode unshaded;

// Combines the depth and normal edge detecting approaches from:
// https://godotshaders.com/shader/depth-based-edge-detection-with-sobel-operator-screenspace/
// https://godotshaders.com/shader/normal-based-edge-detection-with-sobel-operator-screenspace/

// Then, applies turbulent displace effect to the edges from:
// https://www.shadertoy.com/view/MscSzf

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE: hint_depth_texture, filter_linear_mipmap;

group_uniforms edge_detection;

uniform float normal_threshold = 0.5;
uniform float depth_threshold = 3;

uniform vec3 line_color: source_color = vec3(0.0);
uniform vec3 background_color: source_color = vec3(1.0);

const mat3 sobel_y = mat3(
	vec3(1.0, 0.0, -1.0),
	vec3(2.0, 0.0, -2.0),
	vec3(1.0, 0.0, -1.0)
);

const mat3 sobel_x = mat3(
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);

group_uniforms turbulent_displace;

uniform sampler2D NOISE_PATTERN;

uniform float noise_amount = 0.005;
uniform float error_range = 0.001;
uniform float error_period = 0.1;

float linearize_depth(vec2 uv_coord, mat4 proj_matrix){
	float depth = texture(DEPTH_TEXTURE, uv_coord).x;
	vec3 ndc = vec3(uv_coord, depth) * 2.0 - 1.0;
	vec4 view = proj_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
}

float sobel(mat3 surrounding) {
	
	float edge_x = dot(sobel_x[0], surrounding[0]) + dot(sobel_x[1], surrounding[1]) + dot(sobel_x[2], surrounding[2]);
	float edge_y = dot(sobel_y[0], surrounding[0]) + dot(sobel_y[1], surrounding[1]) + dot(sobel_y[2], surrounding[2]);

	float edge = sqrt(pow(edge_x, 2.0)+pow(edge_y, 2.0));
	
	return edge;
}

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	// Turbulent Displace
	float noise = texture(NOISE_PATTERN, uv).r * noise_amount;
	uv = uv + vec2(error_range * sin(error_period * uv.y) + noise, error_range * sin(error_period * uv.x) + noise);
	
	
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	normal = normal * 2.0 - 1.0;
	
	vec4 screen_color = texture(SCREEN_TEXTURE, uv);

	

	vec2 offset = 1.0 / VIEWPORT_SIZE;
	
	// First 3 values are x,y,z normals. Last value is depth
	vec4 c = vec4(normal, linearize_depth(uv, INV_PROJECTION_MATRIX));
	vec4 n = vec4(texture(NORMAL_TEXTURE, uv + vec2(0.0, -offset.y)).rgb, linearize_depth(uv + vec2(0.0, -offset.y), INV_PROJECTION_MATRIX));
	vec4 s = vec4(texture(NORMAL_TEXTURE, uv + vec2(0.0, offset.y)).rgb, linearize_depth(uv + vec2(0.0, offset.y), INV_PROJECTION_MATRIX));
	vec4 e = vec4(texture(NORMAL_TEXTURE, uv + vec2(offset.x, 0.0)).rgb, linearize_depth(uv + vec2(offset.x, 0.0), INV_PROJECTION_MATRIX));
	vec4 w = vec4(texture(NORMAL_TEXTURE, uv + vec2(-offset.x, 0.0)).rgb, linearize_depth(uv + vec2(-offset.x, 0.0), INV_PROJECTION_MATRIX));
	vec4 nw = vec4(texture(NORMAL_TEXTURE, uv + vec2(-offset.x, -offset.y)).rgb, linearize_depth(uv + vec2(-offset.x, -offset.y), INV_PROJECTION_MATRIX));
	vec4 ne = vec4(texture(NORMAL_TEXTURE, uv + vec2(offset.x, -offset.y)).rgb, linearize_depth(uv + vec2(offset.x, -offset.y), INV_PROJECTION_MATRIX));
	vec4 sw = vec4(texture(NORMAL_TEXTURE, uv + vec2(-offset.x, offset.y)).rgb, linearize_depth(uv + vec2(-offset.x, offset.y), INV_PROJECTION_MATRIX));
	vec4 se = vec4(texture(NORMAL_TEXTURE, uv + vec2(offset.x, offset.y)).rgb, linearize_depth(uv + vec2(offset.x, offset.y), INV_PROJECTION_MATRIX));

	mat3 surrounding_depths = mat3(
		vec3(nw.w, n.w, ne.w),
		vec3(w.w,  c.w, e.w),
		vec3(sw.w, s.w, se.w)
	);
	
	mat3 surrounding_normals = mat3(
		vec3(length(nw.rgb-normal), length(n.rgb-normal), length(ne.rgb-normal)),
		vec3(length(w.rgb-normal), length(normal.rgb-normal), length(e.rgb-normal)),
		vec3(length(sw.rgb-normal), length(s.rgb-normal), length(se.rgb-normal))
	);
	
	if (sobel(surrounding_normals) > normal_threshold || sobel(surrounding_depths) > depth_threshold) {
		ALBEDO = line_color; 
	} else {
		ALBEDO = screen_color.rgb;
	}
}