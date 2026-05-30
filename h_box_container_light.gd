extends HBoxContainer

func _on_night_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
