extends Button

const GAME = preload("res://Game.tscn")

@export var music: AudioStreamMP3
@export var obstacles: JSON
@export var level_name: String
@onready var play_container: PlayContainer = get_node("../../..")

func _on_pressed() -> void:
	var game_scene: Game = GAME.instantiate()
	game_scene.difficulty = play_container.difficulty
	game_scene.music_stream = music
	game_scene.obstacles = Array(obstacles.data, TYPE_DICTIONARY, "", null)
	game_scene.level_name = level_name
	
	
	get_tree().root.add_child(game_scene)
	get_tree().current_scene = game_scene
	$"../../../../..".queue_free() # Root Node
