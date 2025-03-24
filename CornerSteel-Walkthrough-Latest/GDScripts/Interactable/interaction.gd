extends RayCast3D

@export_category("INTERACTION SETTINGS")
@onready var prompt_message = $"../../../../../PlayerInterface/PromptText" # Reference to the label node

var last_hit_object # Store the last object hit by raycast 

func _physics_process(_delta: float) -> void:
	search_object()
	
func search_object():
	# Disable the prompt messgae by default
	prompt_message.text = ""
	
	# Remove the save mesh instance by default
	if last_hit_object:
		last_hit_object.set_outline_enabled(false)
		last_hit_object = null
		
	 # Check if the ray hit something
	if is_colliding():
		# Save the object hit buy ray
		var collider = get_collider()
		
		 # Check if its in the "Interactable" group
		if collider is Interactable:
			prompt_message.text = collider.prompt_message
			
			# Check if the collider has a node mesh instance and it can be interact
			if collider.has_node("MeshInstance3D") and collider.can_interact:
				
				var mesh_instance = collider.get_node("MeshInstance3D")
				# Save the mesh instance and enable the outline method on it
				last_hit_object = mesh_instance
				last_hit_object.set_outline_enabled(true)
				
			if Input.is_action_just_pressed("interact_key"):
				collider.interact(owner) # Call the interat function
