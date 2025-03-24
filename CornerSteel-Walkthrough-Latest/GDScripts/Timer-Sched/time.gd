extends Control

@onready var number_hr = $TimeTXT

func _process(_delta: float) -> void:
	number_hr.text = "Time: %02d:%02d:%02d" % [float(Clock.current_hour), float(Clock.current_min), float(Clock.current_sec)]
