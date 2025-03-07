extends ColorRect

#Dispaly or get the current FPS of the game
func _process(_delta: float) -> void:
	$VBoxContainer/Label.text = "FPS:" + str(Engine.get_frames_per_second())
