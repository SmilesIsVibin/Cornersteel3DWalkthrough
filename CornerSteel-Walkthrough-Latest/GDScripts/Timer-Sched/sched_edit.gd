extends Control

@onready var line_hr = $HBoxContainer/LineEdit  #Get Line Edit of mins
@onready var line_min = $HBoxContainer/LineEdit2  # Get Line Edit of mins
@onready var label_Equip = $HBoxContainer/Label  # Get Label for the name of Equipment

var value_hr = 6.0 #value of hours
var value_min = 0 #value of mins

@export var Bus1 : bool
@export var Bus2 : bool 
@export var Bus3 : bool 
@export var Bus4 : bool


@export var Open : bool #Flag For Opne
@export var close : bool #Flag For Close


#----------------------------- For process and Start -----------------------------------
func _ready() -> void:
	default()
	showText()
	checkInput()
func _process(_delta: float) -> void:
	checkInput()

#----------------------------- Getting the Input Value -----------------------------------
#Hour value
func _on_line_edit_text_submitted(new_text: String) -> void: 
	line_hr.release_focus() # remove the focus on Line Edit
	if int(new_text) < 24:
		value_hr = int(new_text)  #get the value of string and converts to int
		showText()
	elif int(new_text) > 24:
		showText()
	print("Hour Value: ", value_hr)
#Limit to Digits only (HRS)
func _on_line_edit_text_changed(new_text: String) -> void:
	var filtered_text = ""
	
	for char in new_text:
		if char.is_valid_int():  # Check if the character is a digit
			filtered_text += char
	
	# Set the filtered text back to the LineEdit
	if line_hr.text != filtered_text:
		line_hr.text = filtered_text
#Clear txt on enter focus in HRS
func _on_line_edit_focus_entered() -> void:
	line_hr.clear()
#Min value
func _on_line_edit_2_text_submitted(new_text: String) -> void:
	line_min.release_focus() # remove the focus on Line Edit
	if int(new_text) < 60:
		value_min = int(new_text)  #get the value of string and converts to int
		showText()
	elif int(new_text) > 60:
		showText()  # clear the txt box
	print("Min Value: ", value_min)
#Limit to Digits only (mins)
func _on_line_edit_2_text_changed(new_text: String) -> void:
	var filtered_text = ""
	
	for char in new_text:
		if char.is_valid_int():  # Check if the character is a digit
			filtered_text += char
	
	# Set the filtered text back to the LineEdit
	if line_min.text != filtered_text:
		line_min.text = filtered_text
#Clear txt on enter focus in mins
func _on_line_edit_2_focus_entered() -> void:
	line_min.clear()
#Update the text in input
func showText() -> void:
	line_hr.text = "%02d" % [float(value_hr)] #display the current hr
	line_min.text = "%02d" % [float(value_min)] # #display the current min

#----------------------------- Getting Starting value -----------------------------------
#Start function
func default() -> void:
	line_hr.max_length = 2
	line_min.max_length = 2
	if Bus1:
		label_Equip.text = "Bus 1"
	elif Bus2:
		label_Equip.text = "Bus 2"
	elif Bus3:
		label_Equip.text = "Bus 3"
	elif Bus4:
		label_Equip.text = "Bus 4"
		
	if Open:
		value_hr = 6.0 #default hr
		value_min = 0.0 #default min
	elif close:
		value_hr = 20.0 #default hr
		value_min = 0.0 #default min

#----------------------------- Check what tab is changing -----------------------------------

#Checks if the Equiqment is for open or close
func checkInput() -> void:
#------------------------------------------------------- Bus1 -----------------------------------------------------------
	if Bus1 && Open:
		Clock.Hrs_Bus1_sched_Open = value_hr
		Clock.Mins_Bus1_sched_Open = value_min
	elif Bus1 && close:
		Clock.Hrs_Bus1_sched_Close = value_hr
		Clock.Mins_Bus1_sched_Close = value_min
		
#------------------------------------------------------- Bus2 -----------------------------------------------------------

	elif Bus2 && Open:
		Clock.Hrs_Bus2_sched_Open = value_hr
		Clock.Mins_Bus2_sched_Open = value_min
	elif Bus2 && close:
		Clock.Hrs_Bus2_sched_Close = value_hr
		Clock.Mins_Bus2_sched_Close = value_min

#------------------------------------------------------- Bus3 -----------------------------------------------------------

	elif Bus3 && Open:
		Clock.Hrs_Bus3_sched_Open = value_hr
		Clock.Mins_Bus3_sched_Open = value_min
	elif Bus3 && close:
		Clock.Hrs_Bus3_sched_Close = value_hr
		Clock.Mins_Bus3_sched_Close = value_min
		
#------------------------------------------------------- Bus4 -----------------------------------------------------------
	elif Bus4 && Open:
		Clock.Hrs_Bus4_sched_Open = value_hr
		Clock.Mins_Bus4_sched_Open = value_min
	elif Bus4 && close:
		Clock.Hrs_Bus4_sched_Close = value_hr
		Clock.Mins_Bus4_sched_Close = value_min
