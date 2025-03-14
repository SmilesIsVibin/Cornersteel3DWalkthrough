extends Control

@onready var number_hr = $Panel/TimeTXT

func _process(_delta: float) -> void:
	number_hr.text = "%02d:%02d" % [float(Clock.current_hour), float(Clock.current_min)]
