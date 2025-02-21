extends Control

func _ready():
	set_anchors_preset(Control.PRESET_CENTER)

func _draw():
	var center = get_viewport_rect().size / 2
	draw_circle(center, 2, Color(1, 1, 1))  # Small white dot
