extends Sprite2D

var components = []
var targets = []
var enzyme_dict = {"amylase": "starch", "protease": "protein", "pepsin" : "protein",
					"lipase": "fats", "maltase" : "maltose", "mucin" : null,
					"water": null, "hydrochloric acid": null, 
					"sodium hydrogen carbonate": null,
					"lysozyme" : "bacteria", "rennin" : "casein",
					"lactase" : "lactose", "bile" : null,
					"milk" :  null}
var filled = false
var moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func fill_up(solution: Array):
	if !filled and !moving:
		components = solution
		for i in components:
			targets.append(enzyme_dict[i])
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
	if components.has("protease"):
		targets.append("polypeptide")
	elif components.has("bile"):
		if body.is_in_group("fats"):
			body.emulsify()
	var group = body.get_groups()
	if group != []:
		if targets.has(group[0]):
			body.break_down()
