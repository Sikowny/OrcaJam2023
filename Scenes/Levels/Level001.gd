class_name Level001
extends AbstractLevel

@onready var level_win_text: CanvasLayer = $Level_Win

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(level_win_text)
	init_progress()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_progress()
	update_timer(delta)
	
	if num_dirty_obj == 0: #victory
		level_complete()
			
			
func level_complete():
	if(time_left <= 0): on_fail()
	time_left -= 1
	add_child(level_win_text)

