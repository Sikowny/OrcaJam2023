extends Node3D
class_name Tool

const AttackType = preload("res://Scripts/Common/AttackType.gd")
const hitbox = preload("res://Scripts/Common/hitbox.gd")
const DirtyObject = preload("res://Scripts/dirty_object.gd")

@export var attackType: AttackType.EAttackType
@export var m_hitbox: hitbox
@export var damage: float = 0.2
@export var attack_delta: float = 1

var targets: Array[DirtyObject]
var active = false
var attack_cooldown: float = 1

func _ready():
	set_physics_process(false)
	attack_cooldown = 0

func on_button_press():
	pass
	
func on_button_release():
	pass

func _area_entered(area):
	if(area.is_in_group("dirty_things")):
		if attackType == area.dirty_type:
			print("dirty area - IN RANGE: " + str(area.dirty_type) + " : " + str(area))
			targets.append(area)

func _on_area_exited(area):
	if(area.is_in_group("dirty_things")):
		if attackType == area.dirty_type:
			print("dirty area - left range: " + str(area.dirty_type) + " : " + str(area))
			targets.erase(area)

func _physics_process(delta):
	attack_cooldown -= delta
	if attack_cooldown > 0:
		return
		
	attack_cooldown = attack_delta + attack_cooldown
	
	for target in targets:
		if target != null:
			if !target.is_processing(): return
			target.hit_clean(damage)
			print("Clean Hit: hp:" + str(target.dirt_health))
	
	targets = targets.filter(func(target): return target != null)	
