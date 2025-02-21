extends Control

@onready var controls_label = $ControlsLabel

func _ready():
	controls_label.text = """
	WASD - Move
	Mouse - Look
	Space - Jump
	Shift + Move Keys - Sprint
	E - Interact/Open Doors
	"""
	controls_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	controls_label.add_theme_color_override("font_color", Color.BLACK)
