extends CharacterBody3D

@export var speed: float = 35.0
@export var gravity: float = 9.8  # Add gravity force
var player: Node3D = null

func _ready():
	player = get_tree().get_first_node_in_group("player")  # Find player in the scene

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Apply gravity
		if not is_on_floor():
			velocity.y -= gravity * delta

		move_and_slide()
		
		# Make the model face the player
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
