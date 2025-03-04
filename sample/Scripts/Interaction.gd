extends RayCast3D

@export_category("INTERACTION SETTINGS")
@export var prompt_text: Label

var hit_object: Node3D = null  # Store the object hit by the ray

func _process(_delta: float) -> void:
	update_ray_hit()

	# Check if the E key is pressed and interact if there's a valid object
	if Input.is_action_just_pressed("Interact_key") and hit_object != null:
		interact_object()
		
func update_ray_hit() -> void:
	hit_object = null  # Reset the hit object

	if is_colliding(): # Check if the ray hit something
		var collider = get_collider()
		
		if collider and collider.is_in_group("Interactable"):
			hit_object = collider  # Store the hit object
			prompt_text.visible = true
			return  # Exit early to avoid setting visible false again

	prompt_text.visible = false  # Hide prompt if no valid object is hit
	
func interact_object() -> void:
	var animation_player = hit_object.get_node("AnimationPlayer")
	if hit_object.has_method("toggle_door") and not animation_player.is_playing():
		hit_object.toggle_door()
