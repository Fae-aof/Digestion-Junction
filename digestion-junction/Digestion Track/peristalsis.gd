extends StaticBody2D

@onready var left_push: CollisionPolygon2D = $"Left Push"
@onready var right_push: CollisionPolygon2D = $"Right Push"


func squeeze():
	var time = 0.8
	var tweenR = create_tween()
	tweenR.tween_property(right_push, "position", Vector2(25, 0), time)
	var tweenL = create_tween()
	tweenL.tween_property(left_push, "position", Vector2(-25, 0), time)
	tweenR.tween_property(right_push, "position", Vector2(70, 0), time/2)
	tweenL.tween_property(left_push, "position", Vector2(-70, 0), time/2)
