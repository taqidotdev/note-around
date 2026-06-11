extends Panel

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_play_again_pressed() -> void:
	var obstacles_container: ObstaclesContainer = get_tree().current_scene.get_node("ObstaclesContainer")
	obstacles_container.score = 0
	obstacles_container.position.x = 0
	obstacles_container.current_obstacle = -1
	obstacles_container._update_next_note()
	
	var player = $"../Player"
	
	var music = $"../Music"
	music.seek(0.0)
	
	hide()
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.show()
	$"../Score".show()
	obstacles_container.dead = false
	music.play()
