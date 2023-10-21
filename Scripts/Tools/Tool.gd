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

func on_button_press():
	pass
	
func on_button_release():
	pass

func _area_entered(area):
	if(area.is_in_group("dirty_things")):
		if attackType == area.dirty_type:
			targets.append(area)

func _physics_process(delta):
	attack_cooldown -= delta
	if attack_cooldown > 0:
		return
		
	attack_cooldown = attack_delta + attack_cooldown
	
	for target in targets:
		if target != null:
			target.hit_clean(damage)
	
	targets = targets.filter(func(target): return target != null)	
