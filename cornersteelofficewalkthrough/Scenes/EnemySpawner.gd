extends Node3D

@export var zombie_scene: PackedScene  # Assign your Zombie.tscn
@export var spawn_points: Array[Node3D]  # Assign spawn locations

func _ready():
	for spawn_point in spawn_points:
		var zombie = zombie_scene.instantiate()
		get_parent().add_child(zombie)
		zombie.global_position = spawn_point.global_position
