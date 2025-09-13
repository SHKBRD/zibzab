shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D float_texture;
uniform sampler2D alpha_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 float_sample = texture(float_texture, vec2(UV.x, UV.y-TIME));
	float alpha_sample = texture(alpha_texture, (UV/3.0)+0.33333).a;
	ALBEDO = float_sample.rgb;
	ALPHA = alpha_sample * float_sample.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
