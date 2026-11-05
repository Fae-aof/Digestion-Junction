extends Area2D

var pH_colour_dict = {2: "db4e23", 8: "60874c"}
@onready var color_rect: ColorRect = $ColorRect

func move_down(pH : int):
	var original_position = global_position
	var target_position = global_position + Vector2(0, 150)
	var target_colour = Color.from_string(pH_colour_dict[pH], Color.WHITE)
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.5)
	tween.tween_property(color_rect, "color", target_colour, 0.4)
	tween.tween_property(self, "global_position", original_position, 0.5)
	
