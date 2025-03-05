extends "res://Scripts/interactable.gd"

@export_category("INTERACTION UI")
@export var prompt_message = ""

var is_door_close := true # flag to check if the door is open or not
@onready var animation_player = $AnimationPlayer # animation player node reference

func _on_interacted(body: Variant) -> void:
	# Only toggle the door if theres no animation playing
	if not animation_player.is_playing():
		toggle_door()
		
func toggle_door():
	if is_door_close:
		animation_player.play("Door_Open")
	else:
		animation_player.play("Door_Close")
		
	is_door_close = !is_door_close # Update the door state
