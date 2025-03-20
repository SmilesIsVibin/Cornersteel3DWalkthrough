extends Control

@onready var line_hr = $HBoxContainer/LineEdit  #Get Line Edit of mins
@onready var line_min = $HBoxContainer/LineEdit2  # Get Line Edit of mins
@onready var label_Equip = $HBoxContainer/Label  # Get Label for the name of Equipment
@onready var btn_Txt = $HBoxContainer/Button  # Get Button

var value_hr = 6.0 #value of hours
var value_min = 0 #value of mins

@export var AC :bool #Flag For AC
@export var Lights :bool #Flag For Lghts
@export var PC : bool #Flag For Pc
@export var Open : bool #Flag For Opne
@export var close : bool #Flag For Close


#----------------------------- For process and Start -----------------------------------
func _ready() -> void:
	default()
	showText()
	checkInput()
func _process(_delta: float) -> void:
	checkInput()
	BTN_On_Off()


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

#----------------------------- Buttons Function for on and off (Equipment) -----------------------------------

#Checks if the Equiqment is for open or close
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
			Clock.ACSwitch = 0
			Clock.is_Ac_on = false
		else:
			Clock.ACSwitch = 3
			Clock.is_Ac_on = true
	elif Lights && close ||Lights && Open:
		if Clock.is_Lights_on:
			Clock.Lights_Switch = 0
			Clock.is_Lights_on = false
		else:
			Clock.Lights_Switch = 3
			Clock.is_Lights_on = true
	elif PC && close || PC && Open:
		if Clock.is_PC_on:
			Clock.is_PC_on = false
		else:
			Clock.is_PC_on = true
