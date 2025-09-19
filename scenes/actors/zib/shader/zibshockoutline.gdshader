shader_type spatial;
render_mode unshaded;

void vertex() {
	VERTEX = VERTEX + VERTEX * vec3((sin(TIME*40.0 * sin(VERTEX.x*33.0) + cos(VERTEX.z*20.0))+1.0)/4.0);
}

void fragment() {
	ALBEDO = vec3(0.0, 1.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
