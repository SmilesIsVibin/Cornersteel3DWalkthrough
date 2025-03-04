extends CharacterBody3D

@export_category("MOVEMENT SETTINGS")
@export var move_speed : float = 5.0 # how fast the movement is
@export var jump_height : float = 4.5 # max height the character can jump
@export var gravity : float = 30.0 # self explanatory
@export var sprint_speed : float = 8.0 # how fast the sprinting is

@export_category("CAMERA SETTINGS")
@export var mouse_sensitivity : float = 0.001 # how fast the camera rotation will be
@export var max_look_limit : float = 80.0 # max limit the character can look up and dowm

@export_category("SMOOTHING EFFECT")
@export var smoothing_speed : float = 10.0 # The speed of smoothing

@export_category("NOCLIP SETTING")
@export var is_noclip : bool = false # flag to check wether noclip is enable / disable
@export var noclip_speed : float = 10.0 # how fast the movement when noclipping

var current_input := Vector3.ZERO # Holds the current smoothed movement input
var current_delta := Vector2.ZERO # Holds the current smoothed mouse input

var mouse_delta := Vector2.ZERO # stores the current mouse motion
var move_vector := Vector3.ZERO # stores the movement direction

var current_speed : float = 0.0 # tracks the current speed of the player

# node reference
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var collision_shape := $CollisionShape3D
@onready var camera3d := $"TwistPivot/PitchPivot/Camera Bobbing/Camera3D"

func _ready() -> void:
	hide_cursor() # hide coruse from the start

func _process(delta: float) -> void:
	handle_rotation(delta)
	toggle_noclip()
	exit_game()
	
func _physics_process(delta: float) -> void:
	handle_noclip(delta)
	handle_movement(delta)
	handle_jumping(delta)
	move_and_slide()
	
func handle_movement(delta):
	# only apply this movement when noclip is disable
	if is_noclip: return
	
	# adjust the current speed based on player input
	current_speed = sprint_speed if Input.is_action_pressed("sprint_key") else move_speed
	
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

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
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
	if Input.is_action_just_pressed("noclip_toggle"):
		is_noclip = !is_noclip
		if is_noclip:
			collision_shape.disabled = true
			# Move the player slightly upward to add feedback when enabling noclip
			position.y += 0.5
		else:
			collision_shape.disabled = false
			
# input section
func get_movement_input() -> Vector3:
	var move_input := Vector3.ZERO
	move_input.x = Input.get_axis("move_left", "move_right")
	move_input.z = Input.get_axis("move_forward", "move_backward")
	
	# return the normalized movement vector
	return move_input.normalized()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			mouse_delta.x = - event.relative.x * mouse_sensitivity
			mouse_delta.y = - event.relative.y * mouse_sensitivity
			
func is_moving() -> bool:
	return move_vector.length() > 0.1 # adjust as needed
	
func hide_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func exit_game():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()  # Exit the game
