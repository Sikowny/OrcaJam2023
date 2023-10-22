class_name DirtyableProp
extends Node3D

const dirty_enemy = preload("res://dirty_enemy.gd")
var dirty_enemy_ref = preload("res://Scenes/dirty_enemy.tscn")
var dirty_obj_ref = preload("res://Scenes/dirty_object.tscn")

var dirty_obj = null

@export var start_dirty: bool = false
@export var dirty_type: AttackType.EAttackType = AttackType.EAttackType.dry
@export var dirty_level: int = 1

@export var m_dirty_enemy: dirty_enemy

@export var spawn_timer: float = 3
var spawn_cooldown: float

var parentObj = null

func _ready():
	edit_prop_material()
	$MeshInstance3D.visible = false
	if get_parent() != null:
		parentObj = get_parent()
	if start_dirty:
		dirty_obj = dirty_obj_ref.instantiate()
		dirty_obj.dirty_type = dirty_type
		dirty_obj.dirt_health = dirty_level
		dirty_obj.is_cleaned.connect(_on_dirty_object_is_cleaned)
		#dirty_obj.scale = Vector3(1,1,1) * dirty_obj_scale
		add_child(dirty_obj)
	
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

# Function for dirty enemy:
# If the enemy see a dirty prop that's clean:
# try and drity it
func try_dirty(_dirty_enemy: dirty_enemy):
	if m_dirty_enemy != null:
		if dirty_obj != null:
			return false
	else:
		#dirty this object
		set_physics_process(true)
		m_dirty_enemy = _dirty_enemy
		dirty_obj = m_dirty_enemy.dirty_obj_ref
		m_dirty_enemy.dirty_obj_ref.is_cleaned.connect( \
						_on_dirty_object_is_cleaned)
		
	dirty_level += 1
	return true


#connected to dirty_obj on start, or when enemy dirtys the prop
func _on_dirty_object_is_cleaned():
	m_dirty_enemy = null
	dirty_obj = null
	dirty_level = 0
	set_physics_process(false)
	edit_prop_material(true)
	
func edit_prop_material(reset = false):
	var prop = get_parent()
	if(!prop): return
	if !(prop is MeshInstance3D): return
	var matCount = prop.get_surface_override_material_count()
	var mat = null
	if(!reset):
		match(str(AttackType.EAttackType.keys()[dirty_type])):
			"dry": mat = preload("res://Assets/Materials/dirty_dry.tres")
			"wet": mat = preload("res://Assets/Materials/dirty_wet.tres")
			"goo": mat = preload("res://Assets/Materials/dirty_goo.tres")
	for i in range(matCount):
		prop.set_surface_override_material(i,mat)
		
	
