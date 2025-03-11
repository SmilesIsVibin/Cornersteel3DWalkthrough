extends "res://GDScripts/Interactable/interactable.gd"

@export_category("INTERACTION UI")
@export var prompt_message = ""
# List to store all OmniLight3D nodes

@onready var light = $OmniLight3D # Node reference of the light
var is_switch_on := true # Tracks the current state of the switch

func _on_interacted(body: Variant) -> void:
	toggle_light()
	
func toggle_light(): # Function use to enable / disable the light object
	if is_switch_on:
		light.visible = false
		
	else:
		light.visible = true
		
	is_switch_on = !is_switch_on # Update the switch state
