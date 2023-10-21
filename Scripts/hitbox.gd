extends Area3D

@export var SPEED: float = 0.0
@export var direction: Vector3 = Vector3.ZERO
@onready var mesh = $CollisionShape3D/MeshInstance3D
@onready var debug_text = $debug_text


#Dry, Wet, Goo
var attack_type = "Dry"
var lifeTime = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_text.text = attack_type
	match attack_type:
		"Dry": mesh.material_override.albedo_color = Color(1,0,0,0.8)
		"Wet": mesh.material_override.albedo_color = Color(0,0,1,0.8)
		"Goo": mesh.material_override.albedo_color = Color(0,1,0,0.8) 
	pass
	#reparent($"../..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * SPEED
	if(lifeTime <= 0): queue_free()
	if(lifeTime): lifeTime -= 1
	


func _on_area_entered(area):
	#print("Area: " + str(area))
	if(area.is_in_group("dirty_things")):
		if attack_type == area.dirty_type:
			print("clean Hit:" + str(area))
			area.hit_clean()
			queue_free()
	
