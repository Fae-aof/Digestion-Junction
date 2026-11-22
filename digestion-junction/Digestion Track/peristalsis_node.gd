extends StaticBody2D

@onready var left_push: CollisionPolygon2D = $"Left Push"
@onready var right_push: CollisionPolygon2D = $"Right Push"

var first = true
var decay = 23

func _ready() -> void:
	var time = 0.2
	var tweenR = create_tween()
	tweenR.tween_property(right_push, "position", Vector2(50, 0), time)
	var tweenL = create_tween()
	tweenL.tween_property(left_push, "position", Vector2(-50, 0), time)

func move():
	if first:
		await get_tree().create_timer(0.2).timeout
		first = false
	var time = 0.5
	var tweenR = create_tween()
	tweenR.tween_property(right_push, "position", right_push.position + Vector2(0, 18), time)
	var tweenL = create_tween()
	tweenL.tween_property(left_push, "position", left_push.position + Vector2(0, 18), time)
	decay -= 1
	if decay <= 0:
		queue_free()
