extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const FRICTION = 1.0
const ACCELERATION = 1.0

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var facing_ray: RayCast3D = $Facing
var hitbox = preload("res://Scenes/hitbox.tscn")


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_move: Vector2 = Vector2.ZERO;

var facing: Vector3 = Vector3.ZERO;


func _ready() -> void:
	spring_arm.spring_length = 15;
	spring_arm.rotation.x = -45;
	facing_ray.target_position = Vector3(0,0,4);
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	handle_gravity(delta)
	handle_jump()
	get_player_input()
	
	# Get the input direction and handle the movement/deceleration.
	handle_movement()
	

	move_and_slide() #update player velocity / physics
	
func get_player_input():
	input_move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
func handle_jump():
	if Input.is_action_just_pressed("key_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		create_hitbox()

func handle_movement():
	var direction := (transform.basis * Vector3(input_move.x, 0, input_move.y)).normalized()
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
	facing_ray.target_position = facing*4 #for debuging
	
func create_hitbox():
	var new_hitbox = hitbox.instantiate()
	new_hitbox.position = position
	add_sibling(new_hitbox) # add this node to parent of player
