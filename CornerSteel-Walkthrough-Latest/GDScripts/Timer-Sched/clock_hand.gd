extends Node2D

# Enum for hand types
enum {HOUR, MINUTE}
const HOUR_HAND_LENGTH = 60
const MINUTE_HAND_LENGTH = 100


# OnReady variables for hand nodes
@onready var minute_hand = $MinHand as Line2D
@onready var hour_hand = $HourHand as Line2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Ensure we update the hand positions every frame
	hour_hand.points[1] = calculate_hand_tip_location(HOUR)
	minute_hand.points[1] = calculate_hand_tip_location(MINUTE)

# Calculate the coordinates of the tip of a clock hand
func calculate_hand_tip_location(hand) -> Vector2:
	var length
	var angle


	match hand:
		MINUTE:
			length = MINUTE_HAND_LENGTH
			angle = deg_to_rad(Clock.current_min * 6.0)  # 360 degrees / 60 minutes = 6 degrees per minute
		HOUR:
			length = HOUR_HAND_LENGTH
			# 360 degrees / 12 hours = 30 degrees per hour, plus 0.5 degrees per minute
			angle = deg_to_rad(Clock.current_hour * 30.0 + Clock.current_min * 0.5)

	# Calculate the hand's tip position in screen space
	var x = length * sin(angle)
	var y = -length * cos(angle)  # Inverse Y for proper orientation

	return Vector2(x, y)
