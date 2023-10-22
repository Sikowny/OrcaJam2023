extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const FRICTION = 1.0
const ACCELERATION = 1.0

@export var nav_agent: NavigationAgent3D
@export var vision: Area3D
@export var dirty_type: AttackType.EAttackType = AttackType.EAttackType.dry
@export var dirt_health: int = 3

@onready var facing_ray: RayCast3D = $Facing
@onready var debug_text: Sprite3D = $debug_text
@onready var mesh: MeshInstance3D = $CollisionShape3D/MeshInstance3D
#@onready var dirty_object: Area3D = $dirty_object

var dirty_object_ref = preload("res://Scenes/dirty_object.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_move: Vector2 = Vector2.ZERO;

var facing: Vector3 = Vector3.ZERO;

var m_target: Node3D
var cur_offset: float

var targets = {}
var m_target_is_player: bool = false

func _ready() -> void:
	get_children()
	ready_dirty_obj()
	set_debug_info()
	
	
func set_debug_info():
	debug_text.text = str(AttackType.EAttackType.keys()[dirty_type])
	print(name + ":" + debug_text.text)
	match debug_text.text:
		"dry": mesh.mesh.material.albedo_color = Color(0.8,0.3,0,1)
		"wet": mesh.mesh.material.albedo_color = Color(0.3,0.4,0.8,1)
		"goo": mesh.mesh.material.albedo_color = Color(0.3,0.8,0.3,1)
	pass
	
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	handle_gravity(delta)
	handle_jump()
	handle_attack()
	
	get_move_input()
	
	# Get the input direction and handle the movement/deceleration.
	handle_movement()

	move_and_slide() #update player velocity / physics
	
	
# set up dirty object attached to this enemy
func ready_dirty_obj():
	var dirty_object = dirty_object_ref.instantiate()
	dirty_object.dirt_health = dirt_health
	dirty_object.dirty_type = dirty_type
	dirty_object.is_cleaned.connect(_on_dirty_object_is_cleaned)
	add_child(dirty_object)
	#new_dirty_object.scale = scale# + Vector3(1,1,1)

func get_move_input():
	for t in targets.values():
		update_cur_target(t)
		
	if m_target == null:
		print("target is null")
		set_target(null, 100, false)
		return
	
			
func handle_jump():
	#if jump and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	pass
	
		
func handle_attack():
	pass
	

func handle_movement():
	var desired_velocity = nav_agent.get_next_path_position()
	desired_velocity = (desired_velocity - global_position).normalized()
#
	update_facing(desired_velocity)
	
	desired_velocity *= SPEED

	if desired_velocity:
		velocity.x = move_toward(velocity.x, desired_velocity.x , ACCELERATION)
		velocity.z = move_toward(velocity.z, desired_velocity.z * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)
		
	velocity.y = 0
		
		
func handle_gravity(delta):
	if not is_on_floor(): velocity.y -= gravity * delta
	
	
func update_facing(direction):
	if direction == Vector3.ZERO: return;
	facing_ray.target_position = facing*2 #for debuging

	
func create_hitbox(type, positionOffset:Vector3 = Vector3(0,1,0)):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.position = positionOffset
	new_hitbox.attack_type = type
	add_child(new_hitbox) # add this node to player.


func _on_dirty_object_is_cleaned() -> void:
	queue_free()

	
func update_cur_target(target: Node3D):
	var target_offset = position.distance_to(target.position)
	var target_is_player = target.is_in_group("player")
	
	if m_target == null:
		set_target(target, target_offset, target_is_player)
		return
	
	if m_target_is_player and target_is_player == false:
		nav_agent.target_position = m_target.position
		return
	
	if target_offset < cur_offset:
		set_target(target, target_offset, target_is_player)
	
		
func set_target(target: Node3D, offset: float, target_is_player: bool):
	m_target = target
	cur_offset = offset
	m_target_is_player = target_is_player
	
	if m_target == null:
		var x = randf_range(-2,2)
		var y = randf_range(-2,2)
		var z = randf_range(-2,2)
		var pos = Vector3(x,y,z)
		nav_agent.target_position = pos
		print("target: null, position: {p}".format({"p": pos}))
	else:
		nav_agent.target_position = target.position
	

func _on_vision_area_3d_body_entered(entered):
	if entered.is_in_group("dirtyable") == false:
		return
	
	if !targets.has(entered.get_instance_id()):
		targets[entered.get_instance_id()] = entered
		

func _on_vision_area_3d_body_exited(leaving):
	if targets.find_key(leaving.get_instance_id()):
		targets.erase(leaving.get_instance_id())


func _on_target_reached():
#	print("target reached")
	pass
	
	
func _on_target_not_reachable():
#	print("target not reachable")
	pass
	
	
func _on_nav_finished():
#	print("on nav finished")
	m_target = null
	cur_offset = 100
	
func _on_path_changed():
	#print("path changed")
	pass
	
func _on_velocity_computed(safe_velocity: Vector3):
#	print("safe_velocity: {sv}".format({"sv": safe_velocity}))
	pass

