extends VBoxContainer
class_name PlayContainer

var difficulty: Game.Difficulty = Game.Difficulty.NORMAL

func _on_easy_toggled(toggled_on: bool) -> void:
	if toggled_on:
		difficulty = Game.Difficulty.EASY
func _on_normal_toggled(toggled_on: bool) -> void:
	if toggled_on:
		difficulty = Game.Difficulty.NORMAL
func _on_hard_toggled(toggled_on: bool) -> void:
	if toggled_on:
		difficulty = Game.Difficulty.HARD
