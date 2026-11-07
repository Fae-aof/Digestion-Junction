extends Area2D

@export var pH_gradient : Gradient

@onready var color_rect: ColorRect = $ColorRect

func move_down(pH : int):
	var original_position = global_position
	var target_position = global_position + Vector2(0, 150)
	var gradient_value : float = float(pH)/14
	var target_colour = pH_gradient.sample(gradient_value)
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.5)
	tween.tween_property(color_rect, "color", target_colour, 0.2)
	tween.tween_property(self, "global_position", original_position, 0.5)
	
func move():
	var original_position = global_position
	var target_position = global_position + Vector2(0, 150)
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.5)
	tween.tween_property(self, "global_position", original_position, 0.5)
