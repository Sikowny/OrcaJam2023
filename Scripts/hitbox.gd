extends Area3D

@export var SPEED: float = 0.0
@export var direction: Vector3 = Vector3.ZERO

#Dust, Wipe, Vacumm
var attackType = "Dust"
var lifeTime = 120;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#reparent($"../..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * SPEED
	if(lifeTime <= 0): queue_free()
	if(lifeTime): lifeTime -= 1
	
