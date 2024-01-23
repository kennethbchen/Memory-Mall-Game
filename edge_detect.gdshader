shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture;

// https://godotshaders.com/shader/depth-based-edge-detection-with-sobel-operator-screenspace/

float linearize_depth(vec2 uv_coord, mat4 proj_matrix){
	// https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html
	// https://nekotoarts.github.io/teaching/how-to-read-depth-buffer
	float depth = texture(DEPTH_TEXTURE, uv_coord).x;
	vec3 ndc = vec3(uv_coord, depth) * 2.0 - 1.0;
	vec4 view = proj_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
}

float check_same(vec4 center, vec4 samplef) {
	
	vec3 center_normal = center.xyz;
	float center_depth = center.w;
	
	vec3 sample_normal = samplef.xyz;
	float sample_depth = samplef.w;
	
	vec3 normal_diff = abs(center_normal - sample_normal);
	bool same_normal = normal_diff.x + normal_diff.y + normal_diff.z < 0.1;
	
	float depth_diff = center_depth - sample_depth;
	bool same_depth = depth_diff < 0.01;
	
	return same_normal && same_depth ? 1.0 : 0.0;
}

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 screen_color = texture(SCREEN_TEXTURE, uv);
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	normal = normal * 2.0 - 1.0;
	
	// Get Depth texture and linearize it
	float linear_depth = linearize_depth(uv, INV_PROJECTION_MATRIX);
	
	vec2 offset = 1.0 / VIEWPORT_SIZE;
	
	// se nw sw ne
	vec2 se_coord = uv + vec2(offset.x, offset.y);
	vec2 nw_coord = uv + vec2(-offset.x, -offset.y);
	vec2 sw_coord = uv + vec2(-offset.x, offset.y);
	vec2 ne_coord = uv + vec2(offset.x, offset.y);
	
	float depth_multiplier = 0.01;
	// https://www.shadertoy.com/view/MscSzf
	vec4 se = vec4(texture(SCREEN_TEXTURE, se_coord).rgb, linearize_depth(se_coord, INV_PROJECTION_MATRIX) * depth_multiplier);
	vec4 nw = vec4(texture(SCREEN_TEXTURE, nw_coord).rgb, linearize_depth(nw_coord, INV_PROJECTION_MATRIX) * depth_multiplier);
	vec4 sw = vec4(texture(SCREEN_TEXTURE, sw_coord).rgb, linearize_depth(sw_coord, INV_PROJECTION_MATRIX) * depth_multiplier);
	vec4 ne = vec4(texture(SCREEN_TEXTURE, ne_coord).rgb, linearize_depth(ne_coord, INV_PROJECTION_MATRIX) * depth_multiplier);
	
	float edge = check_same(se, nw) * check_same(sw, ne);
	
	ALBEDO = vec3(edge);
}