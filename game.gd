extends Node2D

@onready var lines = get_node("Lines");
@onready var player = get_node("Player"); 
@onready var text = get_node("VBoxContainer/C");

func _process(delta: float) -> void:
	
	var player_position = roundi(player.note_index)

	RenderingServer.global_shader_parameter_set("player_position", player_position)
