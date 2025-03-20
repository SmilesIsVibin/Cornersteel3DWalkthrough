extends "res://GDScripts/Interactable/interactable.gd"

@export_category("INTERFACE SETTINGS")
@export var prompt_message = "DOOR"

@export_category("ANIMATION SETTINGs")
@export var animation_speed : float = 3.0 # Speed at which the annimation plays
@export var is_door_flip : bool = false # Flag to check wether the door is flip or not
@export var toggle_delay : float = 1.0 # Speed at which the object can be toggle again
@onready var door_pivot := $DoorPivot # Reference to the door pivot node
@onready var audio_player := $AudioStreamPlayer3D # Reference to the audio player

var target_y_rotation : float = 0.0 # Tracks the current y rotation of the door
var is_door_close := true # Flag to check if the door is open or not
var is_toggling: bool = false  # Prevents rapid toggling
var can_interact : bool = true # Add Delay before toggling again

	# ---------------------- MAIN FUNCTIONS ---------------------
func _ready() -> void:
	update_prompt_text("DOOR" + "\n[" + "E" + "]")
	
func _on_interacted(body: Variant) -> void:
	toggle_door()
	
func _process(delta: float) -> void:
	animate_door(delta)
	

	# ---------------------- DOOR RELATED FUNCTIONS ---------------------
func toggle_door():
	if is_toggling or not can_interact:
		return  # Prevent spamming and disable interaction during cooldown

	enable_interaction(false)
	update_current_state()
	update_prompt_text("")
	
	# Wait for the delay before allowing interaction again
	await get_tree().create_timer(toggle_delay).timeout
	enable_interaction(true)
	update_prompt_text("DOOR" + "\n[" + "E" + "]")
	
func animate_door(delta):
	# Only apply the rotation when the y rotation of the door is not equal to target y rotation
	if door_pivot.rotation_degrees.y != target_y_rotation:
		door_pivot.rotation_degrees.y = lerp(
			door_pivot.rotation_degrees.y, target_y_rotation, animation_speed * delta)
			

	# ---------------------- UTILITY FUNCTIONS ---------------------
func enable_interaction(enable : bool):
	is_toggling = !enable
	can_interact = enable
	
func update_current_state():
		# Toggle door rotation
	if is_door_close:
		target_y_rotation = 90.0 if not is_door_flip else -90.0
	else:
		target_y_rotation = 0.0

	audio_player.play() # Play audio when the state is changed
	is_door_close = !is_door_close  # Toggle door state
	
func update_prompt_text(text : String):
	prompt_message = text
