extends RayCast3D

@export_category("INTERACTION SETTINGS")
@onready var prompt_message = $"../../../../../PlayerInterface/PromptText"

func _physics_process(delta: float) -> void:
	search_object()
	
func search_object():
	# Disable the prompt messgae by default
	prompt_message.text = ""
	
	if is_colliding(): # Check if the ray hit something
		var collider = get_collider()
		if collider is Interactable:
			prompt_message.text = collider.prompt_message + "\n[" + "E" + "]"
			if Input.is_action_just_pressed("interact_key"):
				collider.interact(owner) # Call the interat function
			
