extends Control

@onready var bus_name = $VBoxContainer/Label as Label
@onready var bus_button = $VBoxContainer/HBoxContainer/Button as Button


@export var bus1:bool
@export var bus2:bool
@export var bus3:bool
@export var bus4:bool

func _ready() -> void:
	set_up_buses()


func _process(delta: float) -> void:
	if bus1:
		bus_1()
	elif bus2:
		bus_2()
	elif bus3:
		bus_3()
	elif  bus4:
		bus_4()

#Setting the name of every bus
func set_up_buses() -> void:
	if bus1:
		bus_1()
		bus_name.text = "Bus 1"
	elif bus2:
		bus_2()
		bus_name.text = "Bus 2"
	elif bus3:
		bus_3()
		bus_name.text = "Bus 3"
	elif bus4:
		bus_4()
		bus_name.text = "Bus 4"

#----------------------------------- Toogle function -------------------------------------------------
func _on_button_pressed() -> void:
	if bus1:
		Clock.bus1 = !Clock.bus1
		bus_1()
	elif bus2:
		Clock.bus2 = !Clock.bus2
		bus_2()
	elif bus3:
		Clock.bus3 = !Clock.bus3
		bus_3()
	elif  bus4:
		Clock.bus4 = !Clock.bus4
		bus_4()

#--------------------------------------Checking if the button text is on or off-------------------------------- 
func bus_1() -> void:
	if Clock.bus1:
		bus_button.text = "ON"
	else:
		bus_button.text ="OFF"
func bus_2() -> void:
	if Clock.bus2:
		bus_button.text = "ON"
	else:
		bus_button.text ="OFF"
func bus_3() -> void:
	if Clock.bus3:
		bus_button.text = "ON"
	else:
		bus_button.text ="OFF"
func bus_4() -> void:
	if Clock.bus4:
		bus_button.text = "ON"
	else:
		bus_button.text ="OFF"
