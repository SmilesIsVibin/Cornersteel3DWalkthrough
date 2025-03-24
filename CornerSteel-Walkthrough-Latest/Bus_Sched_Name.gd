extends Control


@onready var name_sched = $MarginContainer/HBoxContainer/Label as Label
@onready var Sched_am = $MarginContainer/HBoxContainer/Label2 as Label
@onready var Sched_Pm = $MarginContainer/HBoxContainer/Label3 as Label


@export var bus1: bool
@export var bus2: bool
@export var bus3: bool
@export var bus4: bool


func _ready() -> void:
	change_text()

func _process(delta: float) -> void:
	change_time()


func change_text() -> void:
	if bus1:
		name_sched.text = "Bus 1"
	elif bus2:
		name_sched.text = "Bus 2"
	elif bus3:
		name_sched.text = "Bus 3"
	elif bus4:
		name_sched.text = "Bus 4"

func change_time() -> void:
	if bus1:
		Sched_am.text = str(Clock.Hrs_Bus1_sched_Open).pad_zeros(2) + ":" + str(Clock.Mins_Bus1_sched_Open).pad_zeros(2)
		Sched_Pm.text = str(Clock.Hrs_Bus1_sched_Close).pad_zeros(2) + ":" + str(Clock.Mins_Bus1_sched_Close).pad_zeros(2)
	elif bus2:
		Sched_am.text = str(Clock.Hrs_Bus2_sched_Open).pad_zeros(2) + ":" + str(Clock.Mins_Bus2_sched_Open).pad_zeros(2)
		Sched_Pm.text = str(Clock.Hrs_Bus2_sched_Close).pad_zeros(2) + ":" + str(Clock.Mins_Bus2_sched_Close).pad_zeros(2)
	elif bus3:
		Sched_am.text = str(Clock.Hrs_Bus3_sched_Open).pad_zeros(2) + ":" + str(Clock.Mins_Bus3_sched_Open).pad_zeros(2)
		Sched_Pm.text = str(Clock.Hrs_Bus3_sched_Close).pad_zeros(2) + ":" + str(Clock.Mins_Bus3_sched_Close).pad_zeros(2)
	elif bus4:
		Sched_am.text = str(Clock.Hrs_Bus4_sched_Open).pad_zeros(2) + ":" + str(Clock.Mins_Bus4_sched_Open).pad_zeros(2)
		Sched_Pm.text = str(Clock.Hrs_Bus4_sched_Close).pad_zeros(2) + ":" + str(Clock.Mins_Bus4_sched_Close).pad_zeros(2)
