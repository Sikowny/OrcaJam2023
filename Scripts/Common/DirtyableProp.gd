class_name DirtyableProp
extends CollisionShape3D

const dirty_enemy = preload("res://dirty_enemy.gd")

@export var m_dirty_enemy: dirty_enemy
@export var dirty_level: int = 0
@export var spawn_timer: float = 3

var spawn_cooldown: float

func _ready():
	dirty_level = 0 if m_dirty_enemy == null else max(1, dirty_level)
	spawn_cooldown = randf_range(0, spawn_timer)
	set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	spawn_cooldown -= delta
	if spawn_cooldown > 0:
		return
		
	spawn_cooldown = spawn_timer + spawn_cooldown
	
	var new_enemy = m_dirty_enemy.duplicate()
	get_parent_node_3d().add_child(new_enemy)
	
	#new_enemy.ready.emit_signal()
	
	#spawn another dirty enemy

func try_dirty(_dirty_enemy: dirty_enemy):
	if m_dirty_enemy != null:
		var _dirty_obj = m_dirty_enemy.dirty_object_ref
		if _dirty_obj != _dirty_enemy.dirty_object_ref.dirty_type:
			return false
	else:
		set_physics_process(true)
		m_dirty_enemy = _dirty_enemy
		m_dirty_enemy.dirty_obj_ref.is_cleaned.connect( \
						_on_dirty_object_is_cleaned)
		
	dirty_level += 1
	return true
	
func _on_dirty_object_is_cleaned():
	m_dirty_enemy = null
	dirty_level = 0
	set_physics_process(false)
	
