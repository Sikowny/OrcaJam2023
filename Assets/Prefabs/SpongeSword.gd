class_name SpongeSword
extends "res://Scripts/Tools/Tool.gd"

@onready var particles: GPUParticles3D = $sponge_sword/GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	particles.emitting = false
	m_hitbox.set_active(false)
	set_physics_process(false)
	
func on_button_press():
	#print("on dust bust enter press")
	visible = true
	particles.emitting = true
	m_hitbox.set_active(true)
	set_physics_process(true)
	
func on_button_release():
	visible = false
#	print("on dust bust exit press")
	particles.emitting = false
	m_hitbox.set_active(false)
	set_process(false)
	set_physics_process(false)


