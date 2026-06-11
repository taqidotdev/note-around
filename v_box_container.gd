extends VBoxContainer

@onready var play_container: VBoxContainer = get_node("../PlayContainer")

func _on_play_pressed() -> void:
	hide()
	play_container.show()


func _on_back_pressed() -> void:
	play_container.hide()
	show()
