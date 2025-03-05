extends "res://Scripts/interactable.gd"

@export_category("INTERACTION UI")
@export var prompt_message = ""

@onready var light = $OmniLight3D # Node reference of light
var is_switch_on := true # Tracks the state of the switch

func _on_interacted(body: Variant) -> void:
	if Input.is_action_just_pressed("Interact_key"):
		toggle_light() # Toggle light on and off
	
func toggle_light():
	if is_switch_on:
		light.visible = false
	else:
		light.visible = true
		
	is_switch_on = !is_switch_on # Update the switch state
