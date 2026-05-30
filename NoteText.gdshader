shader_type canvas_item;

global uniform int player_position;
uniform int note_position;
uniform bool next_note;

const vec3 base_color = vec3(0.37, 0.37, 0.37); 
const vec3 highlighted_color = vec3(0.09, 1, 0.45);
const vec3 next_color = vec3(0.796, 0.212, 0.212);

void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	COLOR.a = alpha;
	
	if (player_position == note_position) {
		COLOR.rgb = highlighted_color;
	} else if (next_note) {
		 COLOR.rgb = next_color;
	} else {
		COLOR.rgb = base_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
