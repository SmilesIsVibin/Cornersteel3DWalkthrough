extends Control


@export var time_multiplier: float = 10.0
var current_min: float = 0.0
var current_hour: float = 0.0
var current_sec: float = 0.0
var UI_Time : bool = false


var Hrs_Ac_sched_Open = 6.0
var Mins_Ac_sched_Open = 0.0
var Hrs_Ac_sched_Close = 20.0
var Mins_Ac_sched_Close = 0.0
var Hrs_Lights_sched_Open = 6.0
var Mins_Lights_sched_Open = 0.0
var Hrs_Lights_sched_Close = 20.0
var Mins_Lights_sched_Close = 0.0
var Hrs_PC_sched_Open = 6.0
var Mins_PC_sched_Open = 0.0
var Hrs_PC_sched_Close = 20.0
var Mins_PC_sched_Close = 0.0

var is_Lights_on: bool = false
var is_PC_on: bool = false
var is_Ac_on: bool = false

var ACSwitch : int = 0
var Lights_Switch : int = 0

func _process(delta: float) -> void:
	_update_time(delta)
	on_off()

func counterOfflight() -> void:
	if not Clock.is_Lights_on:
		Clock.is_Lights_on = true
	elif Clock.is_Lights_on:
		Clock.is_Lights_on = false

func counterOff() -> void:
	if not Clock.is_Ac_on:
		Clock.is_Ac_on = true
	elif Clock.is_Ac_on:
		Clock.is_Ac_on = false

func _update_time(delta: float) -> void:
	current_sec += delta * time_multiplier
	
	if current_sec >= 60.0:
		current_sec -= 60.0
		current_min += 1.0
	
	if current_min >= 60.0:
		current_min -= 60.0
		current_hour += 1.0
	
	if current_hour >= 24.0:
		current_hour -=24.0  # Reset hour to 0 (00:00) after it reaches 24.

func on_off() -> void:
	if current_hour == Hrs_Ac_sched_Open && current_min == Mins_Ac_sched_Open:
		is_Ac_on = true
		Clock.ACSwitch = 3
	elif current_hour == Hrs_Ac_sched_Close && current_min == Mins_Ac_sched_Close:
		is_Ac_on = false
		Clock.ACSwitch = 0
	if current_hour == Hrs_Lights_sched_Open && current_min == Mins_Lights_sched_Open:
		is_Lights_on = true
		Clock.Lights_Switch = 0
	elif current_hour == Hrs_Lights_sched_Close && current_min == Mins_Lights_sched_Close:
		is_Lights_on = false
		Clock.Lights_Switch = 3
	if current_hour == Hrs_PC_sched_Open && current_min == Mins_PC_sched_Open:
		is_PC_on = true
	elif current_hour == Hrs_PC_sched_Close && current_min == Mins_PC_sched_Close:
		is_PC_on = false
