extends CharacterBody3D

@export_category("MOVEMENT SETTINGS")
@export var move_speed : float = 5.0 # how fast the movement is
@export var jump_height : float = 4.5 # max height the character can jump
@export var gravity : float = 30.0 # self explanatory
@export var sprint_speed : float = 8.0 # how fast the sprinting is
var current_speed : float = 0.0 # tracks the current speed of the player

@export_category("CAMERA SETTINGS")
@export var sensitivity : float = 0.001 # how fast the camera rotation will be
@export var max_look_limit : float = 80.0 # max limit the character can look up and dowm

@export_category("CROUCHING SETTINGS")
@export var crouch_speed: float = 3.0 # how fast the crouching is
var is_crouching : bool = false # Tracks the current crouch state

@export_category("SMOOTHING EFFECT")
@export var smoothing_speed : float = 10.0 # The speed of smoothing

@export_category("NOCLIP SETTING")
@export var is_noclip : bool = false # flag to check wether noclip is enable / disable
@export var noclip_speed : float = 10.0 # how fast the movement when noclipping

var current_input := Vector3.ZERO # Holds the current smoothed movement input
var current_delta := Vector2.ZERO # Holds the current smoothed mouse input

var mouse_delta := Vector2.ZERO # stores the current mouse motion
var move_vector := Vector3.ZERO # stores the movement direction

@onready var twist_pivot := $TwistPivot # Reference to the twist pivot node
@onready var pitch_pivot := $TwistPivot/PitchPivot # Reference to the pitchpivot node
@onready var collision_shape := $CollisionShape3D # Reference to the collision shaoe 3d
@onready var camera3d := $"TwistPivot/PitchPivot/CameraBobbing/Camera3D" # Reference to the camera
@onready var animation_player := $AnimationPlayer # Reference the to animation player
@onready var shape_cast3d := $ShapeCast3D # Reference to the shape cast 3d
@onready var player_body : CharacterBody3D = self # Reference to the character body 3d

func _ready() -> void:
	 # hide coruse from the start
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Make the shape cast ignore the player
	shape_cast3d.add_exception(player_body)

func _process(delta: float) -> void:
	  # Exit the game
	if Input.is_action_pressed("exit_key"):
		get_tree().quit()
		
	toggle_noclip()
	
func _physics_process(delta: float) -> void:
	handle_noclip(delta)
	handle_movement(delta)
	handle_rotation(delta)
	handle_jumping(delta)
	handle_crouch()
	move_and_slide()
	

	# ----------------------PLAYER LOCOMOTION FUNCTIONS ---------------------
func handle_movement(delta):
	# only apply this movement when noclip is disable
	if is_noclip: return	
	
	# Get the current speed of the player between (walking, sprinting, crouching)
	current_speed = get_current_speed()
	
	# get the movement input and smooth it out
	var move_input = get_movement_input()
	current_input = current_input.lerp(move_input, smoothing_speed * delta)

	# create direction based on smoothed input
	move_vector = (twist_pivot.basis * Vector3(
		current_input.x, 0, current_input.z))
		
	# only move when theres an movement input
	if move_vector != Vector3.ZERO:
		velocity.x = move_vector.x * current_speed
		velocity.z = move_vector.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
func handle_rotation(delta):
	# smooth out the camera input
	current_delta = current_delta.lerp(mouse_delta, smoothing_speed * delta)
	
	# apply the rotation
	twist_pivot.rotate_y(current_delta.x)
	pitch_pivot.rotate_x(current_delta.y)
	
	# clamp the vertical rotation
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x,
	deg_to_rad(-max_look_limit), deg_to_rad(max_look_limit))
	
	# reset the rotation after applying it
	mouse_delta = Vector2.ZERO
	
func handle_jumping(delta):
	# apply gravity when not grounded
	if not is_noclip and not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump_key") and is_on_floor():
		if !is_crouching:
			velocity.y = jump_height
		
func handle_noclip(delta):
	#Only applythis movement when noclip is anable
	if not is_noclip: return
	
	# Get movement input and create a vector based on that
	var input_vector = get_movement_input()
	var forward = camera3d.global_transform.basis.z
	var right = pitch_pivot.global_transform.basis.x
	
	# Make the vector ralative to player direction
	var movement = (forward * input_vector.z + right * input_vector.x).normalized()
	global_translate(movement * move_speed * 2 * delta)
	
func toggle_noclip():
	# Toggle nocli[ on and off using N key
	if Input.is_action_just_pressed("noclip_key") && !is_crouching:
		is_noclip = !is_noclip
		if is_noclip:
			collision_shape.disabled = true
			velocity = Vector3.ZERO
			# Move the player slightly upward to add feedback when enabling noclip
			position.y += 0.5
		else:
			collision_shape.disabled = false
			
func handle_crouch():
	# Only allow crouching when not noclipping
	if Input.is_action_just_pressed("crouch_key") and !is_noclip:
		
	# Prevent clipping to the wall when standing by using a ray check above
	# the player's head
		if is_crouching and not shape_cast3d.is_colliding():
			animation_player.play("crouch", -1, -crouch_speed, true)
		elif not is_crouching:
			animation_player.play("crouch", -1, crouch_speed)
		

	# ----------------------PLAYER INPUT FUNCTIONS ---------------------
func get_movement_input() -> Vector3:
	var move_input := Vector3.ZERO
	move_input.x = Input.get_axis("move_left", "move_right")
	move_input.z = Input.get_axis("move_forward", "move_backward")
	
	# return the normalized movement vector
	return move_input.normalized()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			mouse_delta += -event.relative * sensitivity
			
	# Combine right stick input
	var look_input = Vector2(
		Input.get_axis("look_left", "look_right"),
		Input.get_axis("look_down", "look_up")
	)
	# Apply sensitivity and add to mouse_delta
	mouse_delta += look_input * sensitivity
	

	# ---------------------- UTILITY FUNCTIONS ---------------------
func get_current_speed() -> float:
	if is_crouching:
		return crouch_speed  # Prioritize crouching over sprinting
		
	elif Input.is_action_pressed("sprint_key"):
		return sprint_speed  # Sprint only if not crouching
		
	else:
		return move_speed  # Default walking speed
		
func is_moving() -> bool:
	return velocity.length() > 0.1 # adjust as needed
	
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "crouch":
		is_crouching = !is_crouching
