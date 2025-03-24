extends Control


#Time Var
@export var time_multiplier: float = 10.0
var current_min: float = 0.0
var current_hour: float = 0.0
var current_sec: float = 0.0
var UI_Time : bool = false

#Busses Schedule Var
#----------------------------- Bus1 ----------------------------------
#Open
var Hrs_Bus1_sched_Open = 6.0
var Mins_Bus1_sched_Open = 0.0
#Close
var Hrs_Bus1_sched_Close = 20.0
var Mins_Bus1_sched_Close = 0.0
#----------------------------- Bus2 ----------------------------------
#Open
var Hrs_Bus2_sched_Open = 6.0
var Mins_Bus2_sched_Open = 0.0
#Close
var Hrs_Bus2_sched_Close = 20.0
var Mins_Bus2_sched_Close = 0.0
#----------------------------- Bus3 ----------------------------------
#Open
var Hrs_Bus3_sched_Open = 6.0
var Mins_Bus3_sched_Open = 0.0
#Close
var Hrs_Bus3_sched_Close = 20.0
var Mins_Bus3_sched_Close = 0.0

#----------------------------- Bus4 ----------------------------------
#Open
var Hrs_Bus4_sched_Open = 6.0
var Mins_Bus4_sched_Open = 0.0
#Close
var Hrs_Bus4_sched_Close = 20.0
var Mins_Bus4_sched_Close = 0.0



#Lights flag
var is_bus1_on: bool = false
var is_bus2_on: bool = false
var is_bus3_on: bool = false
var is_bus4_on: bool = false

#Ac Flags
var is_Ac_on: bool = false
var is_Ac_on2: bool = false
var is_Ac_on3: bool = false
var is_Ac_on4: bool = false


#Pc Flag
var is_PC_on: bool = false



#Bus Flag
var bus1: bool
var bus2: bool
var bus3: bool
var bus4: bool

#Counter 
var ACSwitch : int = 0
var Lights_Switch : int = 0

func _process(delta: float) -> void:
	_update_time(delta)
	on_off()
	check_buses()


func counterOfflight() -> void:
	Clock.is_Lights_on = false
func counterONlight() -> void:
	Clock.is_Lights_on = true

func counterOff() -> void:
	Clock.is_Ac_on = false
func counterOn() -> void:
	Clock.is_Ac_on = true


#------------------------------------------------------- Bus -----------------------------------------------------------
 
#checks if the light is in the bus 1 and so on
func check_buses() -> void:
#------------------------------ Bus 1 -----------------------------------------------
	if bus1: 
		is_bus1_on = true
	else:
		is_bus1_on = false
#------------------------------ Bus 2 -----------------------------------------------
	if bus2:
		is_bus2_on = true
	else:
		is_bus2_on = false
#------------------------------ Bus 3 -----------------------------------------------
	if bus3:
		is_bus3_on = true
	else:
		is_bus3_on = false
#------------------------------ Bus 4 -----------------------------------------------
	if bus4:
		is_bus4_on = true
	else:
		is_bus4_on = false

#------------------------------------------------------- Time Function -----------------------------------------------------------
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
#------------------------------------------------------- Bus1 -----------------------------------------------------------
	if current_hour == Hrs_Bus1_sched_Open && current_min == Mins_Bus1_sched_Open:
		bus1 = true
	elif current_hour == Hrs_Bus1_sched_Close && current_min == Mins_Bus1_sched_Close:
		bus1 = false


#------------------------------------------------------- Bus2 -----------------------------------------------------------
	if current_hour == Hrs_Bus2_sched_Open && current_min == Mins_Bus2_sched_Open:
		Clock.bus2 = true
	elif current_hour == Hrs_Bus2_sched_Close && current_min == Mins_Bus2_sched_Close:
		Clock.bus2 = false


#------------------------------------------------------- Bus3 -----------------------------------------------------------
	if current_hour == Hrs_Bus3_sched_Open && current_min == Mins_Bus3_sched_Open:
		Clock.bus3 = true
	elif current_hour == Hrs_Bus3_sched_Close && current_min == Mins_Bus3_sched_Close:
		Clock.bus3 = false
	
#------------------------------------------------------- Bus4 -----------------------------------------------------------
	if current_hour == Hrs_Bus4_sched_Open && current_min == Mins_Bus4_sched_Open:
		Clock.bus4 = true
	elif current_hour == Hrs_Bus4_sched_Close && current_min == Mins_Bus4_sched_Close:
		Clock.bus4 = false
