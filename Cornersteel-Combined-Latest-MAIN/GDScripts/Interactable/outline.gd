extends MeshInstance3D

@export var outline_material: Material  # Assign an outline material in the Inspector
var original_material: Material

func _ready():
	original_material = get_material_overlay()

func set_outline_enabled(enabled: bool):
	if enabled:
		set_material_overlay(outline_material)  # Apply overlay outline
	else:
		set_material_overlay(original_material)  # Restore original material
