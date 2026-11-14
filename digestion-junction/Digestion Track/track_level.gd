extends CanvasLayer

@onready var solution_maker: CanvasLayer = $"Solution Maker"
@onready var camera: Camera2D = $Camera2D
@onready var mixed_scene = preload("res://Solution Making/mixed_solution.tscn")
@onready var solution_marker: Marker2D = $"Solution Marker"

func _on_to_track_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "global_position", Vector2(1280, 0), 0.4)

func _on_to_lab_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "global_position", Vector2(0, 0), 0.4)


func _on_pour_solution_pressed() -> void:
	add_solution(solution_maker.components)
		
func add_solution(components : Array):
	var new_solution = mixed_scene.instantiate()
	solution_marker.add_child(new_solution)
	new_solution.position = Vector2(0, 0)
	new_solution.fill_up(components)
