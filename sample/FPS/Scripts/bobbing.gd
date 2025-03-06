extends Node3D

@export_category("BOBBING SETTING")
@export var bobbing_speed : float = 10   # Speed of the bobbing
@export var bobbing_amount : float = 0.1  # Vertical movement amount
@export var horizontal_offset : float = 0.05 # Horizontal movement amount

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
		# Make the speed factor ralative to player's current movement speed
		var speed_factor = player.current_speed / player.move_speed

		# Increase bobbing speed based on movement speed
		timer += delta * bobbing_speed * speed_factor

		# Scale bobbing intensity based on speed
		var vertical_bob = sin(timer) * bobbing_amount * speed_factor
		var horizontal_bob = sin(timer * 0.5) * horizontal_offset * speed_factor  # Keep horizontal motion smoother

		# Apply bobbing effect
		position.y = original_position.y + vertical_bob
		position.x = original_position.x + horizontal_bob
	else:
		# Smoothly return to the original position when stopping
		position = position.lerp(original_position, 5 * delta)
