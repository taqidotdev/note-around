extends CharacterBody2D
class_name Player

@onready var note_detector = get_node("NoteDetector")

var note_index: float;
var previous_note: int = 0;
var target: int;
var lives = 3

@export var smoothing = 12;

func _process(delta: float) -> void:
	note_index = ((note_detector._sustained_note_index) % 12) + (floor(note_detector.cents_offset) / 100)
	
	if (note_index > 0):
		target = ((float(11 - note_index) + 0.5) / 12 * 1080)
	
	
	if (note_detector._sustained_note_index > previous_note && note_index < previous_note % 12): # check for upper octave
		global_position.y = 1200
	elif (note_detector._sustained_note_index < previous_note && note_index > previous_note % 12): # check for lower octave
		global_position.y = -120
	else:
		global_position.y = position.lerp(Vector2(0, target), smoothing * delta).y		
	
	previous_note = note_detector._sustained_note_index
	
