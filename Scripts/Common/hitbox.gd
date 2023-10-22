class_name hitbox
extends Area3D

const AttackType = preload("res://Scripts/Common/AttackType.gd")

@export var SPEED: float = 0.0
@export var direction: Vector3 = Vector3.ZERO
@onready var mesh = $CollisionShape3D/MeshInstance3D
# @onready var debug_text = $debug_text

var active: bool

#Dry, Wet, Goo
var attack_type: AttackType.EAttackType = AttackType.EAttackType.dry
var lifeTime = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# debug_text.text = attack_type
	match str(attack_type):
		"0": mesh.material_override.albedo_color = Color(1,0,0,0.8) #dry
		"1": mesh.material_override.albedo_color = Color(0,0,1,0.8) #wet
		"2": mesh.material_override.albedo_color = Color(0,1,0,0.8) #goo
	pass
	#reparent($"../..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	position += direction * SPEED
	# let's control this from the tool
	#if(lifeTime <= 0): queue_free()
	#if(lifeTime): lifeTime -= 1
	


#func _on_area_entered(area):
#	if(area.is_in_group("dirty_things")):
#		print("hit dirty area: " + area.dirty_type + " : " + str(area))
#		if attack_type == area.dirty_type:
#			area.hit_clean()
#			print("Clean Hit: hp:" + str(area.dirt_health))
#			queue_free()
#		else:
#			print("Incorrect Clean Type")
	
	

func set_active(active: bool):
	self.active = active
	set_physics_process(active)
	visible = active
