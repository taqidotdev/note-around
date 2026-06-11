extends Node2D
class_name ObstaclesContainer

const obstacle_node = preload("res://Obstacle.tscn")
const highscore_path = "user://highscores.cfg"

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

# ok i understand its bad to have all my code in this file instead of main game file but stuff works and im too lazy too move it over

@export var obstacles: Array[Dictionary]
@export var obstacle_speed: float = 500
@export var player: Player
@export var player_death_particles: PackedScene
@export var score_label: RichTextLabel
@export var score = 0
@export var added_score_label: RichTextLabel
@export var death_menu: Panel
@export var difficulty_multiplier: float
@export var level_name: String
@export var current_obstacle = -1
var dead = false
var collided = false
var highscore_config: ConfigFile
var highscore: int = -1

@onready var music = $"../Music"
@onready var player_panel = ((player.find_child("PlayerBackground") as Panel).get_theme_stylebox("panel") as StyleBoxFlat)
@onready var death_text = death_menu.get_node("Main")

func _ready() -> void:
	music.connect("finished", _handle_complete)
	highscore_config = ConfigFile.new()
	highscore_config.load(highscore_path)
	var highscore_temp = highscore_config.get_value("highscores", level_name) # make sure not to assign null value
	if (highscore_temp):
		highscore = highscore_temp
	
	var highscore_node = death_menu.get_node("HighScore")
	
	if highscore != -1:
		highscore_node.text = "High Score: " + str(highscore)
	else:
		highscore_node.text = "No High Score"
	
	if difficulty_multiplier:
		for obstacle in obstacles:
			var position_x = (obstacle.time * obstacle_speed) + 250
			
			var obstacle_instance: Obstacle = obstacle_node.instantiate()
			var notes = obstacle.notes
			obstacle_instance.difficulty_multiplier = difficulty_multiplier
			obstacle_instance.position = Vector2(position_x, 0)
			obstacle_instance.notes = Array(obstacle.notes, TYPE_INT, "", null)
			
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
		
		_update_next_note()

func _process(delta: float) -> void:
	if (!dead):
		position.x -= obstacle_speed * difficulty_multiplier * delta
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
		player.process_mode = Node.PROCESS_MODE_DISABLED
		player.hide()
		
		highscore_config.set_value("highscores", level_name, score)
		
		dead = true
		
		await get_tree().create_timer(1).timeout
		
		_handle_complete()
		death_text.text = "You Died!"
		death_text.add_theme_color_override("default_color", Color("cb3636"))
		music.stop()
		
	elif (player.lives == 2):
		player_panel.bg_color = Color(1.694, 1.694, 0.0, 1.0)
		added_score_label.add_theme_color_override("default_color", Color(1.694, 1.694, 0.0, 1.0))
	elif (player.lives == 1):
		player_panel.bg_color = Color(1.694, 0, 0.0, 1.0)
		added_score_label.add_theme_color_override("default_color", Color(1.694, 0.0, 0.0, 1.0))

func _handle_pass(_body: Node2D, obstacle_score) -> void:	
	_update_next_note()
	
	if (!collided):
		var score_gained = 0
		
		if (player.note_detector._sustained_note_index != -1):
			var note_different = true
			for note in obstacles.get(current_obstacle - 1).notes:
				if (note == player.note_detector._sustained_note_index % 12):
					note_different = false
			
			if (note_different):
				score_gained = int(obstacle_score / 2)
			else:
				score_gained = int(obstacle_score * (clampf(1.1 - abs(player.note_detector.cents_offset / 100), 0, 1)))
		
		added_score_label.modulate.a = 1
		added_score_label.text = "+" + str(score_gained) + "/" + str(obstacle_score)
		var fade_out_tween = create_tween()
		fade_out_tween.tween_property(added_score_label, "modulate:a", 0, 1)
		
		var score_tween = create_tween()
		score_tween.tween_property(self, "score", score + score_gained, 0.2)
	else:
		collided = false

func _update_next_note():
	if (current_obstacle >= 0):
		var previous_obstacles = obstacles.get(current_obstacle)
		if (previous_obstacles):
			for note in previous_obstacles.notes:
				($"../VBoxContainer".get_child(11 - note) as RichTextLabel).material.set_shader_parameter("next_note", false)
	
	current_obstacle += 1
	
	var new_obstacles = obstacles.get(current_obstacle)
	
	if (new_obstacles):
		for note in new_obstacles.get("notes"):
			($"../VBoxContainer".get_child(11 - note) as RichTextLabel).material.set_shader_parameter("next_note", true)

func _update_highscore():
	highscore_config.set_value("highscores", level_name, score)
	highscore_config.save(highscore_path)

func _handle_complete():
	death_menu.find_child("Score").text = "Score: " + str(score)
	death_text.text = "You Won!"
	death_text.add_theme_color_override("default_color", Color("008d38"))
	
	if (score > highscore):
		_update_highscore()
	
	# fixes stuff for play again
	player_panel.bg_color = Color(0.0, 1.694, 0.0, 1.0)
	added_score_label.add_theme_color_override("default_color", Color(0.0, 1.694, 0.0, 1.0))
	
	var previous_obstacles = obstacles.get(current_obstacle)
	if (previous_obstacles):
		for note in previous_obstacles.notes:
			($"../VBoxContainer".get_child(11 - note) as RichTextLabel).material.set_shader_parameter("next_note", false)
	
	
	score_label.hide()
	death_menu.show()
