extends "res://FPS/Scripts/interactable.gd"

@export_category("INTERACTION UI")
@export var prompt_message = ""

@onready var light = $OmniLight3D # Node reference of light
var is_switch_on := true # Tracks the state of the switch

func _on_interacted(body: Variant) -> void:
	toggle_light()
	
func toggle_light():
	if is_switch_on:
		light.visible = false
	else:
		light.visible = true
		
	is_switch_on = !is_switch_on # Update the switch state
