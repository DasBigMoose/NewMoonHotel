shader_type spatial;
render_mode cull_disabled;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D glass_normal : hint_normal;
uniform float distortion_size = 0.2;
uniform vec4 glass_color : source_color;
uniform sampler2D glass_texture;
uniform float emission_energy = 1.0;

void fragment() {
	vec2 d = texture(glass_normal, UV).rg * 2.0 - vec2(1.0);
	//ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV + d * distortion_size).rgb * glass_color.rgb;
	//ALPHA = .1;
	EMISSION = texture(glass_texture, UV).rgb * emission_energy;

}
