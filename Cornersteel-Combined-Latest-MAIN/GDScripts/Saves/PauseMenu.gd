extends Control

@export var light2: DirectionalLight3D
var fps_ui: bool = false
var light1: bool = false
@export var pause_panel: Control
@export var fps_rect: ColorRect
var is_paused : bool = false;

func _ready() -> void:
	pause_panel.visible = false
	is_paused = false

# Process is called every frame. It updates the UI and light shadow state.
func _process(_delta: float) -> void:
	_process_me()
	_light_off()
	
	if Input.is_action_just_pressed("pause_key"):
		toggle_panel()

# Enables or disables the shadow on the directional light based on light1's value.
func _light_off() -> void:
	if light1:
		light2.shadow_enabled = true
	else:
		light2.shadow_enabled = false

# Sets the light state and prints its current value.
func set_light_off(value: bool) -> void:
	light1 = value
	print("light1 set to:", light1)

# Updates the fps_ui variable and prints its new value.
func set_fps_ui(value: bool) -> void:
	fps_ui = value
	print("fps_ui set to:", fps_ui)

# Updates the visibility of the UI element based on fps_ui.
func _process_me() -> void:
	if fps_ui:
		fps_rect.visible = true  # Fixed typo here
	else:
		fps_rect.visible = false
		
func toggle_panel(): # Function use to enable / disable the control guide interface
	if is_paused:
		pause_panel.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		pause_panel.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	is_paused = !is_paused
