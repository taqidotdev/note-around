extends Node2D
class_name Game

@onready var lines = get_node("Lines");
@onready var player = get_node("Player"); 
@onready var text = get_node("VBoxContainer/C");
@onready var music: AudioStreamPlayer2D = get_node("Music")

enum Difficulty { 
	# percentage
	EASY = 75,
	NORMAL = 100,
	HARD = 150
}

@export var difficulty: Difficulty = Difficulty.NORMAL
@export var music_stream: AudioStreamMP3
@export var obstacles: Array[Dictionary]
@export var level_name: String

var player_death_particles = preload("res://player_death_particles.tscn")

func _ready() -> void:
	music.stream = music_stream
	music.play()
	var difficulty_multiplier = difficulty / 100.0
	
	var music_bus_index = AudioServer.get_bus_index("Music")
	var pitch_efffect = AudioServer.get_bus_effect(music_bus_index, 0)
	pitch_efffect.pitch_scale = 1 / difficulty_multiplier
	music.pitch_scale = difficulty_multiplier
	
	var obstacles_container = ObstaclesContainer.new()
	obstacles_container.name = "ObstaclesContainer"
	obstacles_container.player = $Player
	obstacles_container.player_death_particles = player_death_particles
	obstacles_container.score_label = $Score
	obstacles_container.added_score_label = $AddedScore
	obstacles_container.death_menu = $DeathMenu
	obstacles_container.difficulty_multiplier = difficulty_multiplier
	obstacles_container.obstacles = obstacles
	obstacles_container.level_name = level_name + str(difficulty)
	
	add_child(obstacles_container)

func _process(delta: float) -> void:
	if player:
		var player_position = roundi(player.note_index)
		RenderingServer.global_shader_parameter_set("player_position", player_position)
