extends Control

@onready var control_panel = $ControlGuidePanel
var is_panel_enable : bool = false;

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("control_key"):
		toggle_panel()
	
func toggle_panel(): # Function use to enable / disable the control guide interface
	if is_panel_enable:
		control_panel.visible = false
	else:
		control_panel.visible = true
	is_panel_enable = !is_panel_enable
