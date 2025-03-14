extends Control

@export var light2: DirectionalLight3D
@export var pause_panel: Control
@export var fps_rect: ColorRect
@export var _Time : Control
@export var Monitor : Array[MeshInstance3D] #Array for set of monitors

@export var WORLD : Node3D
var interactable : Node3D
var Switch_parent : Node3D
var AC_Parent : Node3D
var switch : Array
var ACSwitch : Array

var is_paused : bool = false;
var fps_ui: bool = false
var light1: bool = false
var UI_Time : bool = false

var previous_clock_light_state: bool = true
var previous_clock_AC_state: bool = true


func _ready() -> void:
	get_equipment()
	UI_Time = Clock.UI_Time #checks if the UI of time in game will be on or off
	pause_panel.visible = false
	is_paused = false
# Process is called every frame. It updates the UI and light shadow state.
func _process(_delta: float) -> void:
	UI_Time = Clock.UI_Time
	_process_me()
	_light_off()
	TimeShow()
	monitor_On_OFf()
	rotate_light_based_on_time()
	on_off()
	
	
	if Clock.is_Ac_on != previous_clock_AC_state:
		Ac_ON_OFF()
		previous_clock_AC_state = Clock.is_Ac_on
	#to check if the lights is being change in the pause menu
	if Clock.is_Lights_on != previous_clock_light_state:
		light_energy_low()
		previous_clock_light_state = Clock.is_Lights_on
	# uses to show the Pause menu
	if Input.is_action_just_pressed("pause_key"):
		toggle_panel()
# Enables or disables the shadow on the directional light based on light1's value.
func _light_off() -> void:
	if light1:
		light2.shadow_enabled = true
	else:
		light2.shadow_enabled = false
# Sets the light state and prints its current value.
func _set_light_off(value: bool) -> void:
	light1 = value
	print("light1 set to:", light1)
# Updates the fps_ui variable and prints its new value.
func set_fps_ui(value: bool) -> void:
	fps_ui = value
	print("fps_ui set to:", fps_ui)
# Updates the visibility of the UI element based on fps_ui.
func _process_me() -> void:
	if fps_ui:
		fps_rect.visible = true  
	else:
		fps_rect.visible = false
# Function use to enable / disable the control guide interface
func toggle_panel():
	if is_paused:
		pause_panel.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		pause_panel.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	is_paused = !is_paused
# Function to show Time in game
func TimeShow() -> void:
	if UI_Time:
		_Time.visible = true
	else:
		_Time.visible = false
#Turning off the lights
func light_energy_low() -> void:
	if not Clock.is_Lights_on:
		for sw in switch:
			sw.is_switch_on = true
		print("LightOn")
	else:
		for sw in switch:
			sw.is_switch_on = false
#turning off the monitor
func monitor_On_OFf() -> void:
	if not Clock.is_PC_on:
		for PC in Monitor:
			PC.visible = false
	else:
		for PC in Monitor:
			PC.visible = true
#turning off the AC
func Ac_ON_OFF() -> void:
	print(Clock.is_Ac_on)
	if not Clock.is_Ac_on:
		for ACS in ACSwitch:
			ACS.is_acu_off = false
			ACS.toggle_aircon()
	else:
		for ACS in ACSwitch:
			ACS.is_acu_off = true
			ACS.toggle_aircon()
#Rotation of the Directional light
func rotate_light_based_on_time() -> void:
	var rotation_angle = (Clock.current_hour / 24.0) * 360.0
	light2.rotation_degrees.x = rotation_angle + 90 
#Turning off the energy og light
func on_off() -> void:
	# Example of logic for turning something on or off based on time
	if Clock.current_hour >= 6 and Clock.current_hour < 18:
		# Daytime logic (e.g., light should be bright)
		light2.light_energy = 1.0  # Full intensity during the day
		light2.light_color = Color(1, 1, 1)  # White light (sunlight)
	else:
		# Nighttime logic (e.g., light should be dim or off)
		light2.light_energy = 0  # Dim light or you can set to 0 for complete darkness
		light2.light_color = Color(0.2, 0.2, 0.5)  # Blueish night light or you can set it to black for darkness
#get all the need variables for the pause menu
func get_equipment()-> void:
	interactable =  WORLD.get_node("Interactables")
	Switch_parent = interactable.get_node("Switches")
	AC_Parent = interactable.get_node("AC_Units")
	switch = Switch_parent.get_children()
	ACSwitch = AC_Parent.get_children()
