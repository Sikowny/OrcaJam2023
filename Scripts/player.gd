extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const FRICTION = 1.0
const ACCELERATION = 1.0

const Tool = preload("res://Scripts/Tools/Tool.gd")
const InputMapConst = preload("res://Scripts/InputMapConst.gd")

#grab refences to connected nodes on this Scene/Object
@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var facing_ray: RayCast3D = $Facing

#preload another object to instanciate it later
var hitbox = preload("res://Scenes/hitbox.tscn")
var p_dustbuster = preload("res://Assets/Prefabs/DustBuster.tscn")

#set up vars
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_move: Vector2 = Vector2.ZERO;

var facing: Vector3 = Vector3.ZERO;

var toolbelt: Array[Tool]
var tool1: Tool
var tool2: Tool

func _ready() -> void:
	spring_arm.spring_length = 15;
	spring_arm.rotation.x = -45;
	facing_ray.target_position = Vector3(0,0,4);
	
	tool1 = p_dustbuster.instantiate()
	add_child(tool1)

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	handle_gravity(delta)
	handle_jump()
	handle_attack()
	get_player_input()
	
	# Get the input direction and handle the movement/deceleration.
	handle_movement()
	

	move_and_slide() #update player velocity / physics
	
func get_player_input():
	input_move = Input.get_vector(InputMapConst.move_left,\
								  InputMapConst.move_right,\
								  InputMapConst.move_up,\
								  InputMapConst.move_down)
	
func handle_jump():
	if Input.is_action_just_pressed(InputMapConst.jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func handle_attack():
	var pOffSet = facing + Vector3(0,1,0)
	if Input.is_action_just_pressed(InputMapConst.action1):
		#create_hitbox("Dry", pOffSet)
#		print("basic interaction pressed")
		return
	elif Input.is_action_just_released(InputMapConst.action1):
#		print("basic interaction released")
		return
		
	if Input.is_action_just_pressed(InputMapConst.action2):
		#create_hitbox("Wet", pOffSet)
#		print("tool 2 primary action pressed")
		if tool2:
			tool2.on_button_press()
			return	
	elif Input.is_action_just_pressed(InputMapConst.action2):
#		print("tool 2 primary action released")
		if tool2:
			tool2.on_button_release()
		return
		
	if Input.is_action_just_pressed(InputMapConst.action3):
		#create_hitbox("Goo", pOffSet)
#		print("tool 1 primary action pressed")
		if tool1:
			tool1.on_button_press()
			return
	elif Input.is_action_just_released(InputMapConst.action3):
#		print("tool 1 primary action released")
		if tool1:
			tool1.on_button_release()
			return
			
	if Input.is_action_just_pressed(InputMapConst.toolbelt_L):
		print("swap tools left")
	elif Input.is_action_just_pressed(InputMapConst.toolbelt_R):
		print("swap tools right")

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
	
	#parented camera makes this not a good idea at the moment
	#transform = transform.rotated(Vector3.UP, Vector3.FORWARD.dot(direction))
	
func create_hitbox(type, positionOffset:Vector3 = Vector3(0,1,0)):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.position = positionOffset
	new_hitbox.attack_type = type
	add_child(new_hitbox) # add this node to player.
