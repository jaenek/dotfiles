uniform vec2 u_resolution;
uniform float u_time;

void main() {
	vec2 uv = (gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;
	float t = u_time;



	vec3 col = vec3(0);

	gl_FragColor = vec4(col, 1);
}
