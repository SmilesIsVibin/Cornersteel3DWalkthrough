extends Control

@export var build_number: String = "Cornersteel Office Walkthrough Prototype Build: 1.0.0 by Prynze Sebastian Reyes (Very Basic Build, WALKSPEED = 25, SPRINTSPEED = 50, GRAV = 100, MOUSESENS = 0.004)"  # Editable in the Inspector

@onready var shadow_label = $ShadowLabel
@onready var controls_label = $ControlsLabel
@onready var fps_label = Label.new()  # Create a new label for FPS
@onready var fps_bg = ColorRect.new()  # Background for FPS label

func _ready():
	# Set text
	shadow_label.text = build_number
	controls_label.text = """
	WASD/Left Controller Stick - Move
	Mouse/Right Controller Stick - Look
	E/Left Mouse Click/Controller X - Interact/Open Doors
	Space/Controller A - Jump
	Shift + Move Keys/LT + Left Stick - Sprint
	N/Controller Y - Toggle Noclip (Space to go up, Ctrl to go down)
	Esc/Start - CLOSE GAME
	"""

	# Apply colors
	shadow_label.add_theme_color_override("font_color", Color(0, 0, 0))  # Black shadow
	controls_label.add_theme_color_override("font_color", Color.BLACK)

	# Adjust font size dynamically
	var font_size = 18  # Change this for bigger/smaller text
	shadow_label.add_theme_font_size_override("font_size", font_size)
	controls_label.add_theme_font_size_override("font_size", font_size)

	# Position controls_label at the bottom left
	controls_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	controls_label.position = Vector2(10, get_viewport_rect().size.y - controls_label.size.y - 10)

	# Configure FPS label
	fps_label.text = "FPS: 0"
	fps_label.add_theme_color_override("font_color", Color.GREEN)  # Green text
	fps_label.add_theme_font_size_override("font_size", font_size)
	fps_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	fps_label.position = Vector2(get_viewport_rect().size.x - 100, 10)  # Top-right position
	
	# Configure FPS background
	fps_bg.color = Color(0, 0, 0, 0.5)  # Black with 50% transparency
	fps_bg.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	fps_bg.custom_minimum_size = Vector2(100, 30)  # Background size
	fps_bg.position = Vector2(get_viewport_rect().size.x - 110, 5)  # Slightly offset for padding
	
	# Add FPS background first, then label (so text is on top)
	add_child(fps_bg)
	add_child(fps_label)

func _process(delta):
	fps_label.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
