extends Sprite2D

var components = []
var enzyme_dict = {"amylase": "starch", "protease": "protein", "lipase": "fats", "water": ""}
var enzyme_color_dict = {"amylase": "ff9dff53", "protease": "98ffff53", "lipase": "ffff8253", "water": "ffffff53"}
var filled = false
var moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func fill_up(solution: String):
	if !filled and !moving:
		components.append(enzyme_dict[solution])
		modulate = enzyme_color_dict[solution]
		moving = true
		var tween_p = create_tween()
		tween_p.tween_property(self, "position", position + Vector2(0, -135), 0.5)
		var tween_s = create_tween()
		tween_s.tween_property(self, "scale", Vector2(1, 0.97), 0.5)
		await get_tree().create_timer(0.5).timeout
		filled = true
		moving = false


func add_solution(solution: String):
	components.append(enzyme_dict[solution])

func empty():
	if filled and !moving:
		moving = true
		var tween_p = create_tween()
		tween_p.tween_property(self, "position", position - Vector2(0, -135), 0.5)
		var tween_s = create_tween()
		tween_s.tween_property(self, "scale", Vector2(1, 0.05), 0.5)
		await get_tree().create_timer(0.5).timeout
		filled = false
		moving = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	for i in components:
		if i != "" and body.is_in_group(i):
			body.break_down()
