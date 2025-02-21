extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		var hitObj = get_collider()
		if hitObj.has_method("interact") and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("controller_interact") or Input.is_action_just_pressed("click_interact") or Input.is_action_just_pressed("F_interact")):
			hitObj.interact()
