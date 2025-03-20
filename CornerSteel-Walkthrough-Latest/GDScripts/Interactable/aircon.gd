extends StaticBody3D

@onready var particle = $Airblow_Particle # Reference to the GPU Particles on each aircon
@onready var audio_player = $AudioStreamPlayer3D # Refernce to the audio stream player 3d

var is_active # Flag to check whether this aircon is active or not

func set_aircon_state(state : bool):
	is_active = state
	particle.emitting = state
	
	if is_active:
		audio_player.play()
	else:
		audio_player.stop()
