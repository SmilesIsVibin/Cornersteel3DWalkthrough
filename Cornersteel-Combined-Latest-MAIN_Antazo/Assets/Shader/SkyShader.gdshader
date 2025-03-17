shader_type sky;

uniform vec3 skycolor: source_color;
uniform vec3 horizoncolor : source_color;
uniform sampler2D skytexture;

void sky() {
	float col = clamp(EYEDIR.y / 0.05 , 0.0, 1.0);
	vec3 finalcolor= mix(horizoncolor, skycolor,col);
	COLOR = texture(skytexture,SKY_COORDS).rgb;
}
