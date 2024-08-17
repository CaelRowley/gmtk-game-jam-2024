shader_type canvas_item;
render_mode unshaded;

uniform float height : hint_range(0.0, 1.0, 0.1);
uniform float tiling = 1;
uniform sampler2D surface_gradient;
uniform sampler2D space_gradient;
uniform float pan_speed = 0.001;
uniform sampler2D noise_tex_a: repeat_enable;
uniform sampler2D noise_tex_b: repeat_enable;

void vertex() {
	
}

void fragment() {
	vec2 uv = UV;
	uv *= tiling;
	uv -= vec2(0.5, 0.5) * tiling;
	uv += vec2(0, -height);
	
	vec2 uv_a = uv + vec2(TIME * pan_speed, 0);
	vec2 uv_b = uv + vec2(TIME * pan_speed / 2.0, 0);
	float t = texture(noise_tex_a, uv_a).r;
	t += texture(noise_tex_b, uv_b).r;
	t /= 2.0;
	t += 1.0 - UV.y;
	t = round((t / 2.0) * 8.0) / 8.0;
	
	vec3 surface_color = texture(surface_gradient, vec2(t, t)).rgb;
	vec3 space_color = texture(space_gradient, vec2(t, t)).rgb;
	COLOR = vec4(mix(surface_color, space_color, height), 1);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
