extends Node



@onready var level_win_text: CanvasLayer = $Level_Win

var goto_main_timer = 240
var level_won = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(level_win_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var check_things = get_tree().get_nodes_in_group("dirty_things").is_empty()
	if(check_things): level_won = true
	if(level_won): level_complete()
			
			
func level_complete():
	if(goto_main_timer == 0): get_tree().change_scene_to_file("res://Scenes/Levels/Level001.tscn")
	goto_main_timer -= 1
	add_child(level_win_text)
