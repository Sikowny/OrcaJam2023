@tool
extends Sprite3D
@onready var sub_viewport = $SubViewport
@onready var label = $SubViewport/Label

var text: String = "Test"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = text
	#sub_viewport.size = label.rect_size
	pass
