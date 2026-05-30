shader_type canvas_item;

global uniform int player_position;
uniform vec4 base_color; 

void fragment() {
	
	float uv_note = SCREEN_UV.y * 12.0;
	
	float uv = fract(uv_note);
    
	float line_mask;
	
	if (SCREEN_UV.y > 0.005) {
		line_mask = step(0.95, uv);
	} else {
		line_mask = 1.0;
	}
	
	int uv_note_int = int(uv_note) + 1;
	
	if (player_position >= 0 && (uv_note_int == player_position || uv_note_int - 1 == player_position)) {
		COLOR = vec4(base_color.rgb, 0.54) * clamp(line_mask, 0.0, 1.0);
	} else if (player_position >= 0 && (uv_note_int + 1 == player_position || uv_note_int - 2 == player_position)) {
		COLOR = vec4(base_color.rgb, 0.26) * clamp(line_mask, 0.0, 1.0);
	} else {
		COLOR = base_color * clamp(line_mask, 0.0, 1.0);
	}
}