extends Control


@onready var name_ = $HBoxContainer/Label as Label
@onready var slider_ = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "MUSIC", "SFX") var bus_name : String

var bus_index : int =0

func _ready() -> void:
	slider_.value_changed.connect(on_changed)
	get_busname()
	set_name_Label()
	set_slider()

func set_name_Label() -> void:
	name_.text = str(bus_name) + " Volume"
	
func get_busname() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider() -> void:
	slider_.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func on_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
