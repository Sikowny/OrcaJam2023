class_name AbstractLevel
extends Node

@export var goto_main_timer: float = 240

signal sig_progress_update(progress: float)

var level_won = false
var targets_cleaned: float = 0
var num_dirty_obj: int
var min_cleaned_targets: float

func init_progress():
	min_cleaned_targets = get_tree().get_nodes_in_group("dirty_things").size()
	

func update_progress():
	num_dirty_obj = get_tree().get_nodes_in_group("dirty_things").size()
	
	var progress = 1 - (num_dirty_obj / min_cleaned_targets)
	sig_progress_update.emit(progress)
