extends CharacterBody3D

const SPEED = 25.0
const CROUCH_SPEED = 15.0
const SPRINT_SPEED = 50.0  
const JUMP_VELOCITY = 30
const SENSITIVITY = 0.004  
const CONTROLLER_SENSITIVITY = 0.07

var gravity = 100
var mouse_visible = false
var is_crouching = false
var is_sprinting = false
var is_noclip = false  # Noclip state

# Health System
@export var max_health: int = 100
var current_health: int = max_health

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collision_shape = $CollisionShape3D

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("Player HP:", current_health)

func _unhandled_input(event):
	if not mouse_visible and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(60))  

func _physics_process(delta: float) -> void:
	# Toggle noclip mode
	if Input.is_action_just_pressed("go_noclip") or Input.is_action_just_pressed("controller_noclip"):
		is_noclip = not is_noclip
		if is_noclip:
			velocity = Vector3.ZERO  # Stop movement when toggling
			collision_shape.disabled = true  # Disable collisions
		else:
			collision_shape.disabled = false  # Enable collisions

	# Handle gravity if not in noclip mode
	if not is_noclip and not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping (disabled in noclip mode)
	if (Input.is_action_just_pressed("go_jump") or Input.is_action_just_pressed("controller_jump")) and is_on_floor() and not is_noclip:
		velocity.y = JUMP_VELOCITY

	# Handle crouching (disabled in noclip mode)
	if not is_noclip:
		if Input.is_action_pressed("go_crouch") or Input.is_action_pressed("controller_crouch"):
			if not is_crouching:
				is_crouching = true
				collision_shape.scale.y = 0.5  
				camera.position.y -= 0.5  
		else:
			if is_crouching:
				is_crouching = false
				collision_shape.scale.y = 1.0  
				camera.position.y += 0.5  

	# Sprinting is enabled in both normal and noclip modes
	is_sprinting = Input.is_action_pressed("go_sprint") or Input.is_action_pressed("controller_sprint")

	# Get movement input
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var controller_input: Vector2 = Input.get_vector("controller_move_left", "controller_move_right", "controller_move_forward", "controller_move_back")

	if is_noclip:
		# Move in the exact direction of the camera, including up/down
		var move_speed = SPRINT_SPEED if is_sprinting else SPEED
		var move_direction = camera.global_transform.basis * Vector3(input_dir.x + controller_input.x, 0, input_dir.y + controller_input.y)
		
		# Apply vertical movement for up/down keys
		if Input.is_action_pressed("go_jump") or Input.is_action_pressed("controller_jump"):
			move_direction.y += 1  # Move up
		if Input.is_action_pressed("go_crouch") or Input.is_action_pressed("controller_crouch"):
			move_direction.y -= 1  # Move down

		velocity = move_direction.normalized() * move_speed
	else:
		# Normal movement with physics
		var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x + controller_input.x, 0, input_dir.y + controller_input.y)).normalized()
		var move_speed = CROUCH_SPEED if is_crouching else (SPRINT_SPEED if is_sprinting else SPEED)

		if direction.length() > 0:
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0

	move_and_slide()

	# Controller look input
	var look_input = Input.get_vector("controller_look_left", "controller_look_right", "controller_look_up", "controller_look_down")
	head.rotate_y(-look_input.x * CONTROLLER_SENSITIVITY)
	camera.rotate_x(-look_input.y * CONTROLLER_SENSITIVITY)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(60))

	# Toggle mouse mode and exit
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("controller_exit"):
		get_tree().quit()  
	elif Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("controller_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_visible = false

# Function to take damage
func take_damage(amount: int):
	current_health -= amount
	print("Player HP:", current_health)

	if current_health <= 0:
		die()

# Function for player death
func die():
	print("Player has died!")
	queue_free()  # Removes the player from the scene (you can add a respawn system later)
