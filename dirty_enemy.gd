extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const FRICTION = 1.0
const ACCELERATION = 1.0

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

func _ready() -> void:
	# set up dirty object attached to this enemy
	ready_dirty_obj()
	# debug info
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
	
	
func ready_dirty_obj():
	var dirty_object = dirty_object_ref.instantiate()
	dirty_object.dirt_health = dirt_health
	dirty_object.dirty_type = dirty_type
	dirty_object.is_cleaned.connect(_on_dirty_object_is_cleaned)
	add_child(dirty_object)
	#new_dirty_object.scale = scale# + Vector3(1,1,1)

func get_move_input():
	#input_move = 
	pass
	
func handle_jump():
	#if jump and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	pass
		
func handle_attack():
	pass

func handle_movement():
	#var direction := (transform.basis * Vector3(input_move.x, 0, input_move.y)).normalized()
	var direction = Vector3.ZERO
	update_facing(direction)
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)
		
func handle_gravity(delta):
	if not is_on_floor(): velocity.y -= gravity * delta
	
func update_facing(direction):
	if direction == Vector3.ZERO: return;
	facing = direction.normalized()
	facing_ray.target_position = facing*2 #for debuging
	
	#parented camera makes this not a good idea at the moment
	#transform = transform.rotated(Vector3.UP, Vector3.FORWARD.dot(direction))
	
func create_hitbox(type, positionOffset:Vector3 = Vector3(0,1,0)):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.position = positionOffset
	new_hitbox.attack_type = type
	add_child(new_hitbox) # add this node to player.



func _on_dirty_object_is_cleaned() -> void:
	queue_free()
