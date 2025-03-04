extends StaticBody3D

# flag to check if the door is open or not
var is_door_close := true

# animation player node reference
@onready var animation_player = $AnimationPlayer

func toggle_door():
	if is_door_close:
		animation_player.play("Door_Open")
	else:
		animation_player.play("Door_Close")
		
	is_door_close = !is_door_close
