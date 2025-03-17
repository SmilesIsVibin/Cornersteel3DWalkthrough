extends Control

@export var light2: DirectionalLight3D
@export var worldcolor: WorldEnvironment
@export var pause_panel: Control
@export var fps_rect: ColorRect
@export var _Time : Control
@export var Monitor : Array[MeshInstance3D] #Array for set of monitors

var transition_speed: float = 1.0  # Controls how fast the transition occurs
var target_sky_top_color: Color
var target_sky_horizon_color: Color
var target_ground_bottom_color: Color
var target_ground_horizon_color: Color

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

#---------------------------------------------- calling and setting up function --------------------------------------------------------------

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
	rotate_light_based_on_time(_delta)
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

#---------------------------------------------- Turning on of a panel --------------------------------------------------------------
# Enables or disables the shadow on the directional light based on light1's value.
func _light_off() -> void:
	if light1:
		light2.shadow_enabled = true
	else:
		light2.shadow_enabled = false
# Sets the light state and prints its current value.
func _set_light_off(value: bool) -> void:
	light1 = value
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

	is_paused = !is_paused
# Function to show Time in game
func TimeShow() -> void:
	if UI_Time:
		_Time.visible = true
	else:
		_Time.visible = false

#---------------------------------------------- Pause --------------------------------------------------------------
# Function use to enable / disable the control guide interface
func toggle_panel():
	if is_paused:
		Engine.time_scale = 1
		pause_panel.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Engine.time_scale = 0
		pause_panel.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#---------------------------------------------- Automatic Function --------------------------------------------------------------
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

#get all the need variables for the pause menu
func get_equipment()-> void:
	interactable =  WORLD.get_node("Interactables")
	Switch_parent = interactable.get_node("Switches")
	AC_Parent = interactable.get_node("AC_Units")
	switch = Switch_parent.get_children()
	ACSwitch = AC_Parent.get_children()

#---------------------------------------------- Sky BOX --------------------------------------------------------------
#Rotation of the Directional light
func rotate_light_based_on_time(_delta: float) -> void:
	var rotation_angle = (Clock.current_hour / 24.0) * 360.0
	var target_rotation = rotation_angle + 90
	light2.rotation_degrees.x = lerp(light2.rotation_degrees.x, target_rotation, _delta * 0.1) 
#Turning off the energy of light
func on_off() -> void:
	#Morning
	if Clock.current_hour >= 6 and Clock.current_hour < 14:
		change_sky_color_blue()
		light2.light_energy = 1  # Dim light or you can set to 0 for complete darkness
		light2.light_color = Color(1, 1, 1)   # White light (sunlight)
	#Noon
	elif Clock.current_hour >= 14 and Clock.current_hour < 18:
		change_sky_color_orange()
		light2.light_energy = 1  # Dim light or you can set to 0 for complete darkness
		light2.light_color = Color(0.945, 0.541, 0.608)   # Orange (sunlight)/ noon
	#Night
	else:
		change_sky_color_black()
		light2.light_energy = 1.0  # Full intensity during the day
		light2.light_color = Color(0.007, 0.017, 0.062) #Dark

func start_sky_transition():
	var sky_mat = worldcolor.environment.sky.sky_material
	var current_sky_top_color = sky_mat.get_shader_parameter("sky_top_color")
	var current_sky_horizon_color = sky_mat.get_shader_parameter("sky_horizon_color")
	var current_ground_bottom_color = sky_mat.get_shader_parameter("ground_bottom_color")
	var current_ground_horizon_color = sky_mat.get_shader_parameter("ground_horizon_color")
	
	# Gradually transition colors over time
	await get_tree().create_timer(0.02).timeout  # Call every frame

	while current_sky_top_color != target_sky_top_color or current_sky_horizon_color != target_sky_horizon_color or current_ground_bottom_color != target_ground_bottom_color or current_ground_horizon_color != target_ground_horizon_color:
		# Interpolate each color
		current_sky_top_color = current_sky_top_color.lerp(target_sky_top_color, transition_speed * get_process_delta_time())
		current_sky_horizon_color = current_sky_horizon_color.lerp(target_sky_horizon_color, transition_speed * get_process_delta_time())
		current_ground_bottom_color = current_ground_bottom_color.lerp(target_ground_bottom_color, transition_speed * get_process_delta_time())
		current_ground_horizon_color = current_ground_horizon_color.lerp(target_ground_horizon_color, transition_speed * get_process_delta_time())


		# Set the updated values
		sky_mat.set_shader_parameter("sky_top_color", current_sky_top_color)
		sky_mat.set_shader_parameter("sky_horizon_color", current_sky_horizon_color)
		sky_mat.set_shader_parameter("ground_bottom_color", current_ground_bottom_color)
		sky_mat.set_shader_parameter("ground_horizon_color", current_ground_horizon_color)

		# Wait for the next frame
		await get_tree().create_timer(0.02).timeout

# Change sky to black (night)
func change_sky_color_black() -> void:
	target_sky_top_color = Color(0.007, 0.017, 0.062)
	target_sky_horizon_color = Color(0, 0, 0)
	target_ground_bottom_color =  Color(0.031, 0.023, 0.015)
	target_ground_horizon_color = Color(0, 0, 0)
	start_sky_transition()

# Change sky to blue (morning)
func change_sky_color_blue() -> void:
	target_sky_top_color = Color(0.385, 0.454, 0.55)
	target_sky_horizon_color = Color(0.646, 0.656, 0.67)
	target_ground_bottom_color = Color(0.2, 0.169, 0.133)
	target_ground_horizon_color = Color(0.646, 0.656, 0.67)
	start_sky_transition()

# Change sky to orange (noon)
func change_sky_color_orange() -> void:
	target_sky_top_color = Color(0.945, 0.541, 0.608)
	target_sky_horizon_color = Color(1, 0.706, 0.502)
	target_ground_bottom_color = Color(0.2, 0.169, 0.133)
	target_ground_horizon_color = Color(1, 0.706, 0.502)
	start_sky_transition()
