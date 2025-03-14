extends Control

@onready var line_hr = $HBoxContainer/LineEdit
@onready var line_min = $HBoxContainer/LineEdit2
@onready var label_Equip = $HBoxContainer/Label
@onready var btn_Txt = $HBoxContainer/Button
var value_hr = 6.0
var value_min = 0

@export var AC :bool 
@export var Lights :bool 
@export var PC : bool
@export var Open : bool
@export var close : bool

func _ready() -> void:
	default()
	showText()
	checkInput()

func _process(_delta: float) -> void:
	checkInput()
	BTN_On_Off()
#Hour value
func _on_line_edit_text_submitted(new_text: String) -> void: 
	line_hr.release_focus() # remove the focus on Line Edit
	if int(new_text):
		value_hr = int(new_text)  #get the value of string and converts to int
		showText()
	else:
		line_hr.text = "Error" #Display Error
		await get_tree().create_timer(2.0).timeout
		line_hr.clear()  # clear the txt box
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

#min value
func _on_line_edit_2_text_submitted(new_text: String) -> void:
	line_min.release_focus() # remove the focus on Line Edit
	if int(new_text):
		value_min = int(new_text)  #get the value of string and converts to int
		showText()
	else:
		line_min.text = "Error" #Display Error
		await get_tree().create_timer(2.0).timeout
		line_min.clear()  # clear the txt box
	print("Hour Value: ", value_hr)

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
	line_hr.clear()

#Checks if the scene is for open or close
func checkInput() -> void:
	if AC && Open:
		Clock.Hrs_Ac_sched_Open = value_hr
		Clock.Mins_Ac_sched_Open = value_min
	elif AC && close:
		Clock.Hrs_Ac_sched_Close = value_hr
		Clock.Mins_Ac_sched_Close = value_min
	elif Lights && Open:
		Clock.Hrs_Lights_sched_Open = value_hr
		Clock.Mins_Lights_sched_Open = value_min
	elif Lights && close:
		Clock.Hrs_Lights_sched_Close = value_hr
		Clock.Mins_Lights_sched_Close = value_min
	elif PC && Open:
		Clock.Hrs_PC_sched_Open = value_hr
		Clock.Mins_PC_sched_Open = value_min
	elif PC && close:
		Clock.Hrs_PC_sched_Close = value_hr
		Clock.Mins_PC_sched_Close = value_min
#Start function
func default() -> void:
	line_hr.max_length = 2
	line_min.max_length = 2
	if AC:
		label_Equip.text = "Aircon"
	elif Lights:
		label_Equip.text = "Lights"
	elif PC:
		label_Equip.text = "Computers"
		
	if Open:
		value_hr = 6.0 #default hr
		value_min = 0.0 #default min
	elif close:
		value_hr = 20.0 #default hr
		value_min = 0.0 #default min
#Update the text in input
func showText() -> void:
	line_hr.text = "%02d" % [float(value_hr)] #display the current hr
	line_min.text = "%02d" % [float(value_min)] # #display the current min
#uses button to turn off or on the ligths pc or ac
func _on_button_pressed() -> void:
	bttnChanger()
#Changing Txt of button in both OPEN and Close Tab
func BTN_On_Off() -> void:
	if AC && close || AC && Open:
		if Clock.is_Ac_on:
			btn_Txt.text = "ON"
		else:
			btn_Txt.text = "OFF"
	elif Lights && close ||Lights && Open:
		if Clock.is_Lights_on:
			btn_Txt.text = "ON"
		else:
			btn_Txt.text = "OFF"
	elif PC && close || PC && Open:
		if Clock.is_PC_on:
			btn_Txt.text = "ON"
		else:
			btn_Txt.text = "OFF"
#Changing the flag for turning on and off the Object in the scene
func bttnChanger() -> void:
	if AC && close || AC && Open:
		if Clock.is_Ac_on:
			Clock.ACSwitch = 3
			Clock.is_Ac_on = false
		else:
			Clock.ACSwitch = 0
			Clock.is_Ac_on = true
	elif Lights && close ||Lights && Open:
		if Clock.is_Lights_on:
			Clock.Lights_Switch = 3
			Clock.is_Lights_on = false
		else:
			Clock.Lights_Switch = 0
			Clock.is_Lights_on = true
	elif PC && close || PC && Open:
		if Clock.is_PC_on:
			Clock.is_PC_on = false
		else:
			Clock.is_PC_on = true
