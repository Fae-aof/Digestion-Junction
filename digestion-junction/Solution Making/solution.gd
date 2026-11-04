extends Area2D

@onready var liquid: CollisionShape2D = $CollisionShape2D
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func fill_up():
	var rect_shape = liquid.shape as RectangleShape2D
	var tween_p = create_tween()
	tween_p.tween_property(liquid, "position", Vector2(0, -120), 0.5)
	var tween_s = create_tween()
	tween_s.tween_property(rect_shape, "size", Vector2(240, 260), 0.5)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("starch"):
		body.break_into_maltose()

func empty():
	var rect_shape = liquid.shape as RectangleShape2D
	var tween_p = create_tween()
	tween_p.tween_property(liquid, "position", Vector2(0, 0), 0.5)
	var tween_s = create_tween()
	tween_s.tween_property(rect_shape, "size", Vector2(240, 5), 0.5)
