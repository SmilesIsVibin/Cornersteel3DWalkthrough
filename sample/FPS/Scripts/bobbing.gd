extends Node3D

@export_category("BOBBING SETTING")
@export var bobbing_speed : float = 10   # Speed of the bobbing
@export var bobbing_amount : float = 0.02  # Vertical movement amount
@export var horizontal_offset : float = 0.005 # Horizontal movement amount

# Refenrence to the player node
@onready var player : CharacterBody3D = get_parent().get_parent().get_parent()

var timer : float = 0.0  # Timer to control the bobbing
var original_position := Vector3.ZERO # store the original position of this node

func _ready() -> void:
	# save the original y position of this node
	original_position = position
	
func _process(delta):
	apply_bobbing(delta)
	
func apply_bobbing(delta):
	if player.is_moving():
		# Relative scaling factor (1 when walking, >1 when sprinting)
		var speed_factor =  player.current_speed / player.move_speed
		
		 # Increase bobbing speed when sprinting
		timer += delta * bobbing_speed * speed_factor

		# Parabolic movement for the vertical bobbing
		var vertical_bob = sin(timer) * bobbing_amount
		
		# Simple horizontal offset
		var horizontal_bob = sin(timer * 0.5) * horizontal_offset  # slower to smooth the horizontal motion
		
		# Apply the bobbing to the camera's position
		position.y += vertical_bob
		position.x += horizontal_bob
		return
	
	position = position.lerp(original_position, 5 * delta)
