shader_type canvas_item;

uniform vec4 inner_color: source_color = vec4(1.0);

group_uniforms shader_parameters.box;
uniform float width: hint_range(0, 1) = 0.5;
uniform float height: hint_range(0, 1) = 0.5;
uniform float corner_radius: hint_range(0, 1) = 0.2;

group_uniforms shader_parameters.wiggle;
uniform float wiggle_speed = 1;
uniform float wiggle_period = 11.0;
uniform float wiggle_range = 0.007;
uniform sampler2D NOISE_TEXTURE;

// https://www.shadertoy.com/view/4llXD7
// https://iquilezles.org/articles/distfunctions2d/
float sdRoundBox( in vec2 p, in vec2 b, in vec4 r ) 
{	
	// Transform the distance function so that the box is in the center
	p -= vec2(0.5);
	b /= 2.0;
	
	// Check distance
    r.xy = (p.x>0.0)?r.xy : r.zw;
    r.x  = (p.y>0.0)?r.x  : r.y;
    vec2 q = abs(p)-b+r.x;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r.x;
}

void fragment() {
	
	vec2 uv = UV;
	
	// Distort the uv coordinate for a wavy effect
	float noise = texture(NOISE_TEXTURE, uv).r;
	uv.x += wiggle_range * sin(uv.y * wiggle_period + TIME * wiggle_speed) + wiggle_range;
	uv.y += wiggle_range * cos(uv.x * wiggle_period + TIME * wiggle_speed) + wiggle_range;
	
	// Sample the SDF and pick color based on it
	float d = sdRoundBox(uv, vec2(width, height), vec4(corner_radius));
	vec4 col = (d>0.0) ? vec4(0.0,0.0,0.0,0.0) : inner_color;
	
	//COLOR = vec4(uv.xy, 0.0, 1.0);
	COLOR = col;
}

