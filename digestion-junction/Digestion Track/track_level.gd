extends CanvasLayer

@onready var solution_maker: CanvasLayer = $"Solution Maker"
@onready var camera: Camera2D = $Camera2D
@onready var mixed_scene = preload("res://Solution Making/mixed_solution.tscn")
@onready var solution_marker: Marker2D = $"Solution Marker"
@onready var label: RichTextLabel = $"Components List/MarginContainer/RichTextLabel"
@onready var spawner: Node2D = $Spawner
@onready var part_label: Label = $"Part Label"

@onready var track: Node2D = $Track

var answers
var correct = []
var done_count = 0

func _ready() -> void:
	answers = track.current_ans

func _on_to_track_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "global_position", Vector2(1280, 0), 0.4)

func _on_to_lab_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "global_position", Vector2(0, 0), 0.4)


func _on_pour_solution_pressed() -> void:
	var incorrect = solution_maker.components.duplicate()
	for i in solution_maker.components:
		if answers.has(i):
			incorrect.erase(i)
			if !correct.has(i):
				correct.append(i)
				done_count += 1
	add_solution(correct)
	label.text = ""
	for i in correct:
		label.push_color("196b00")
		label.append_text(i + "\n")
	for i in incorrect:
		label.push_color("6b0000")
		label.append_text(i + "\n")
	if done_count == answers.size():
		label.push_font_size(40)
		label.push_color("196b00")
		label.append_text("All Done!")
		track.area_complete()

func add_solution(components : Array):
	var new_solution = mixed_scene.instantiate()
	solution_marker.add_child(new_solution)
	new_solution.position = Vector2(0, 0)
	new_solution.fill_up(components)


func _on_up_pressed() -> void:
	var time = 0.4
	var tween = create_tween()
	tween.tween_property(track, "global_position", track.global_position + Vector2(0, 250), time)
	var tweenS = create_tween()
	tweenS.tween_property(spawner, "global_position", spawner.global_position + Vector2(0, 250), time)
	var tweenSo = create_tween()
	tweenSo.tween_property(solution_marker, "global_position", solution_marker.global_position + Vector2(0, 250), time)

func _on_down_pressed() -> void:
	var time = 0.4
	var tween = create_tween()
	tween.tween_property(track, "global_position", track.global_position + Vector2(0, -250), time)
	var tweenS = create_tween()
	tweenS.tween_property(spawner, "global_position", spawner.global_position + Vector2(0, -250), time)
	var tweenSo = create_tween()
	tweenSo.tween_property(solution_marker, "global_position", solution_marker.global_position + Vector2(0, -250), time)
