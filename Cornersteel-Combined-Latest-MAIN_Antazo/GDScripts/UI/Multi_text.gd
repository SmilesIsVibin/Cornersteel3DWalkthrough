extends Label

@onready var multi_text = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	multi_text.text = str(Clock.time_multiplier)
