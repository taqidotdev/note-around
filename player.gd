extends CharacterBody2D

@onready var note_detector = get_node("NoteDetector")

var note_index: float;
var target: int;

@export var smoothing = 10.0;

func _process(delta: float) -> void:
	note_index = ((note_detector._sustained_note_index + 1) % 12) + (floor(note_detector.cents_offset) / 100)
	
	if (note_index > 0):
		global_position.y = position.lerp(Vector2(0, float(note_index) / 12 * 1080), smoothing * delta).y
