extends CharacterBody2D

@onready var note_detector = get_node("NoteDetector")

var note_index: float;
var target: int;

@export var smoothing = 10;

func _process(delta: float) -> void:
	note_index = ((note_detector._sustained_note_index) % 12) + (floor(note_detector.cents_offset) / 100)
	
	if (note_index > 0):
		target = (float(note_index) + 0.5) / 12 * 1080
	
	global_position.y = position.lerp(Vector2(0, target), smoothing * delta).y
	
