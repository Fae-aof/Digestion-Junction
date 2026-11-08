extends Sprite2D

var component
var enzyme_dict = {"amylase": "starch", "protease": "protein",
					"lipase": "fats", "maltase" : "maltose", "mucin" : null,
					"water": null, "hydrochloric acid": null, 
					"sodium hydrogen carbonate": null}
var filled = false
var moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func fill_up(solution: String, colour : String):
	if !filled and !moving:
		component = enzyme_dict[solution]
		modulate = colour
		moving = true
		var tween_p = create_tween()
		tween_p.tween_property(self, "position", position + Vector2(0, -130), 0.5)
		var tween_s = create_tween()
		tween_s.tween_property(self, "scale", Vector2(1.02, 1.1), 0.5)
		await get_tree().create_timer(0.5).timeout
		filled = true
		moving = false

func empty():
	if filled and !moving:
		moving = true
		var tween_p = create_tween()
		tween_p.tween_property(self, "position", position - Vector2(0, -130), 0.5)
		var tween_s = create_tween()
		tween_s.tween_property(self, "scale", Vector2(1.02, 0.05), 0.5)
		await get_tree().create_timer(0.5).timeout
		filled = false
		moving = false
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if component == null:
		pass
	elif component == "protein":
		if body.is_in_group("protein") or body.is_in_group("polypeptide"):
			body.break_down()
	elif body.is_in_group(component):
		body.break_down()
