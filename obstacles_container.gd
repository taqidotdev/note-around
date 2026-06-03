extends Node2D

const obstacle_node = preload("res://Obstacle.tscn")

enum {
	C = 0,
	CS = 1,
	D = 2,
	DS = 3,
	E = 4,
	F = 5,
	FS = 6,
	G = 7,
	GS = 8,
	A = 9,
	AS = 10,
	B = 11
}

@export var obstacles: Array[Dictionary] = [{"time": 3.0, "notes": [A]}, {"time": 6.5, "notes": [F, D], "score": 100}, {"time": 10, "notes": [E]}, {"time": 12, "notes": [G]}]
@export var obstacle_speed: float = 500
@export var player: Player
@export var player_death_particles: PackedScene
@export var score_label: RichTextLabel
@export var score = 0
@export var added_score_label: RichTextLabel
@export var death_menu: Panel
var dead = false
var collided = false

@onready var player_panel = ((player.find_child("PlayerBackground") as Panel).get_theme_stylebox("panel") as StyleBoxFlat)

func _ready() -> void:		
	for obstacle in obstacles:
		var position_x = obstacle.time * obstacle_speed
		
		var obstacle_instance: Obstacle = obstacle_node.instantiate()
		var notes = obstacle.notes
		obstacle_instance.position = Vector2(position_x, 0)
		obstacle_instance.notes = Array(obstacle.notes, TYPE_INT, "", null)  # need to typecast or else it throws error
		
		obstacle_instance.body_entered.connect(_handle_collision)
		
		var pass_area_collision = CollisionShape2D.new()
		var pass_area_rect = RectangleShape2D.new()
		pass_area_rect.size = Vector2(1, 1080)
		pass_area_collision.shape = pass_area_rect
		pass_area_collision.position = Vector2(40, 540)
		
		var pass_area = Area2D.new()
		pass_area.add_child(pass_area_collision)		
		pass_area.position = Vector2.ZERO
		pass_area.body_entered.connect(_handle_pass.bind(obstacle.get("score", 100)))
		
		obstacle_instance.add_child(pass_area)
		add_child(obstacle_instance)

func _process(delta: float) -> void:
	if (!dead):
		position.x -= obstacle_speed * delta
		score_label.text = str(score)
	
func _handle_collision(_body: Node2D) -> void:
	collided = true
	player.lives -= 1
	
	var _particle = player_death_particles.instantiate()
	_particle.process_material.color = player_panel.bg_color
	_particle.position = player.position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	
	if (player.lives <= 0):        
		get_tree().current_scene.remove_child(player)
		
		dead = true
		
		await get_tree().create_timer(1).timeout
		
		death_menu.find_child("Score").text = "Score: " + str(score)
		
		score_label.hide()
		death_menu.show()
	elif (player.lives == 2):
		player_panel.bg_color = Color(1.694, 1.694, 0.0, 1.0)
		added_score_label.add_theme_color_override("default_color", Color(1.694, 1.694, 0.0, 1.0))
	elif (player.lives == 1):
		player_panel.bg_color = Color(1.694, 0, 0.0, 1.0)
		added_score_label.add_theme_color_override("default_color", Color(1.694, 0, 0.0, 1.0))

func _handle_pass(_body: Node2D, obstacle_score) -> void:
	if (!collided):
		var score_gained = 0
		
		if (player.note_detector._sustained_note_index != -1):
			score_gained = int(obstacle_score * (clampf(1.1 - abs(player.note_detector.cents_offset / 100), 0, 1)))
		
		added_score_label.modulate.a = 1
		added_score_label.text = "+" + str(score_gained) + "/" + str(obstacle_score)
		var fade_out_tween = create_tween()
		fade_out_tween.tween_property(added_score_label, "modulate:a", 0, 1)
		
		var score_tween = create_tween()
		score_tween.tween_property(self, "score", score + score_gained, 0.2)
	else:
		collided = false
