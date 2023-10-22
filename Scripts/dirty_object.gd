extends Area3D

const AttackType = preload("res://Scripts/Common/AttackType.gd")

@export var SPEED: float = 0.0
@export var direction: Vector3 = Vector3.ZERO
@onready var debug_text = $debug_text
@onready var mesh = $CollisionShape3D/MeshInstance3D
var tag = "dirty"

#Dry, Wet, Goo
@export var dirty_type: AttackType.EAttackType = AttackType.EAttackType.dry
var dirt_health: int = 3;
var lifeTime = 120;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("dirty_things")
	debug_text.text = str(AttackType.EAttackType.keys()[dirty_type])
	print(name + ":" + debug_text.text)
	match debug_text.text:
		"dry": 
			mesh.mesh.material.albedo_color = Color(0.6,0.25,0,0.8)
		"wet": 
			mesh.mesh.material.albedo_color = Color(0.3,0.5,0.6,0.8)
		"goo": 
			mesh.mesh.material.albedo_color = Color(0.45,0.6,0.3,0.8)
	pass
	#reparent($"../..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if overlaps_area(hitbox):
		#print("hello")
	if(dirt_health <= 0): queue_free()
	pass
	
func hit_clean(damage: float):
	dirt_health -=1
