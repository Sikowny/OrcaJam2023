extends AbstractLevel


@onready var wet_things: Node3D = $"Wet Things"
@onready var dry_things: Node3D = $"Dry Things"
@onready var goo_things: Node3D = $"Goo Things"
@onready var tut_win: CanvasLayer = $Tut_Win


@onready var dirty_Wet1: Node3D = $"Wet Things/Desk/DirtyableProp"
@onready var dirty_Wet2: Node3D = $"Wet Things/LoungeSofa/DirtyableProp"
@onready var dirty_Dry1: Node3D = $"Dry Things/BedSingle/DirtyableProp"
@onready var dirty_Dry2: Node3D = $"Dry Things/BookcaseClosedWide/DirtyableProp"
@onready var dirty_Goo1: Node3D = $"Goo Things/Bathtub/DirtyableProp"
@onready var dirty_Goo2: Node3D = $"Goo Things/Toilet/DirtyableProp"

var tutStage: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(wet_things)
	remove_child(goo_things)
	remove_child(tut_win)
	
	min_cleaned_targets = 6
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_progress()
	
	match(tutStage):
		0:
			if(dirty_Dry1.dirty_obj == null) and (dirty_Dry2.dirty_obj == null):
				tutStage = 1
				add_child(wet_things)
		1:
			if(dirty_Wet1.dirty_obj == null) and (dirty_Wet2.dirty_obj == null):
				tutStage = 2
				add_child(goo_things)
		2:
			if(dirty_Goo1.dirty_obj == null) and (dirty_Goo2.dirty_obj == null):
				tutStage = 3
		3:
			tutorial_complete()
			
			
func tutorial_complete():
	if(goto_main_timer == 0): get_tree().change_scene_to_file("res://Scenes/Levels/Level001.tscn")
	goto_main_timer -= 1
	add_child(tut_win)
