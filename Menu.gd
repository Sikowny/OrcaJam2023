extends Control


func _process(delta: float) -> void:
	scale.x = size.x / ProjectSettings.get_setting("display/window/size/viewport_width")
	scale.y = size.y / ProjectSettings.get_setting("display/window/size/viewport_height")
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level001.tscn")


func _on_credits_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()
	
