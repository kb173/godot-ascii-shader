shader_type spatial;
render_mode unshaded;

uniform sampler2D character_map;

uniform vec2 character_size = vec2(8.0, 16.0);

void vertex() {
	// Cover the viewport with the mesh
	POSITION = vec4(VERTEX, .5);
}

void fragment() {
	vec2 character_count = VIEWPORT_SIZE / character_size;
	
	// Clamp the screen UV coordinates to the future ASCII character grid
	vec2 clamped_uv = floor(SCREEN_UV * character_count) / character_count;
	vec2 uv_cutoff = SCREEN_UV * character_count - floor(SCREEN_UV * character_count);
	
    vec3 color = textureLod(SCREEN_TEXTURE, clamped_uv, 0.0).rgb;
	
	float grey = (color.x + color.y + color.z) / 3.0;
	
	vec2 offset = vec2(floor(grey * 7.0) / 8.0, 0.0);
	
	color *= texture(character_map, offset + uv_cutoff * vec2(1.0/8.0, -1.0)).a;
	
	ALBEDO = color;
}