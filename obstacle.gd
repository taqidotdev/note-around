extends Area2D
class_name Obstacle

@export var notes: Array[int] = [];

var holes: Array[Array] = []

func _ready() -> void:
	for note in notes:
		holes.push_back([int((float(11 - note)) / 12 * 1080), int((float(11 - note + 1)) / 12 * 1080)])
	
	var previous_hole_end = -1;
	var hole_index = 0
	
	holes.sort()
	
	while hole_index < holes.size():
		var hole_start = holes[hole_index][0];
		var hole_end = holes[hole_index][1];
		
		# if two holes are consecutive, merge them
		if (previous_hole_end == hole_start): 
			holes[hole_index - 1][1] = hole_end
			holes.pop_at(hole_index)
		else: 
			hole_index += 1
		
		previous_hole_end = hole_end
	
	hole_index = 0
	var bar_start = 0
	var bar_end = 0
	
	while bar_end != 1080:
		
		var bar_length
		var bar_position
		var rect = ColorRect.new()
		var collision = CollisionShape2D.new()
		
		if (hole_index < holes.size()):
			bar_end = holes[hole_index][0]
			
			bar_length = bar_end - bar_start
			bar_position = bar_start
			
			bar_start = holes[hole_index][1]
		else:
			bar_end = 1080
			
			bar_length = bar_end - bar_start
			bar_position = bar_start
		
		rect.color = Color(1.694, 0.0, 0.0, 1.0)
		rect.size = Vector2(40, bar_length)
		rect.position = Vector2(0, bar_position)
		
		var collision_rect = RectangleShape2D.new()
		collision_rect.size = Vector2(40, bar_length)
		
		collision.shape = collision_rect
		collision.position = Vector2(20, bar_position + bar_length/2)
		
		add_child(rect)
		add_child(collision)
		hole_index += 1
