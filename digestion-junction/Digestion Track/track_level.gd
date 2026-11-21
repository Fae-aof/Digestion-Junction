extends CanvasLayer

@onready var solution_maker: CanvasLayer = $"Solution Maker"
@onready var camera: Camera2D = $Camera2D
@onready var mixed_scene = preload("res://Solution Making/mixed_solution.tscn")
@onready var solution_marker: Marker2D = $"Solution Marker"
@onready var label: RichTextLabel = $"Components List/MarginContainer/RichTextLabel"
@onready var spawner: Node2D = $Spawner
@onready var part_label: Label = $"Part Label"
@onready var track: StaticBody2D = $"Track Spot/Track"
@onready var score: Label = $Score
@onready var components: GridContainer = $Components

@onready var answer_text: RichTextLabel = $Answers/MarginContainer/RichTextLabel
var labels

@onready var push: Button = $Push

var y_coords = [0, 450, 315]
var y_mrk = 0

var answers
var correct = []
var done_count = 0

var not_moving = true

var sections = ["At Mouth", "At Stomach", "At Small Intestine"]
var guide = ["The mouth produces saliva that destroys bacteria, breaks down starch and softens food."]

func _process(delta: float) -> void:
	score.text = "Score: " + str(track.score)
	
func _ready() -> void:
	labels = components.get_children()
	part_label.text = sections.pop_front()
	answers = track.current_ans
	answer_text.text = guide[0]

func _on_to_track_pressed() -> void:
	for i in labels:
		i.text = ""
		i.add_theme_color_override("font_color", Color("3c1902"))
	var count = 0
	for i in solution_maker.components:
		labels[count].text = i
		count += 1
	var tween = create_tween()
	tween.tween_property(camera, "global_position", camera.global_position + Vector2(1280, 0), 0.4)

func _on_to_lab_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "global_position", camera.global_position - Vector2(1280, 0), 0.4)


func _on_pour_solution_pressed() -> void:
	var incorrect = solution_maker.components.duplicate()
	for i in solution_maker.components:
		if answers.has(i):
			incorrect.erase(i)
			if !correct.has(i):
				correct.append(i)
				done_count += 1
	label.text = ""
	for i in labels:
		if correct.has(i.text):
			i.add_theme_color_override("font_color", Color("196b00"))
		else:
			i.add_theme_color_override("font_color", Color("8b0000"))
	if done_count == answers.size() and incorrect == []:
		track.area_complete()
		answers = track.current_ans
		correct = []
		done_count = 0
		if sections != []:
			part_label.text = sections.pop_front()
	#for i in correct:
		#label.push_color("196b00")
		#label.append_text(i + "\n")
	#for i in incorrect:
		#label.push_color("6b0000")
		#label.append_text(i + "\n")
	#if done_count == answers.size():
		#label.push_font_size(40)
		#label.push_color("196b00")
		#label.append_text("All Done!")
		#track.area_complete()
		#answers = track.current_ans
		#correct = []
		#done_count = 0
		#answer_text.text = "Mix the following and pour\n" + str(answers)
		#if sections != []:
			#part_label.text = sections.pop_front()
		
	

func add_solution(components : Array):
	var new_solution = mixed_scene.instantiate()
	solution_marker.add_child(new_solution)
	new_solution.position = Vector2(0, 0)
	new_solution.fill_up(components)


func _on_up_pressed() -> void:
	if not_moving and y_mrk > 0:
		not_moving = false
		var dist = y_coords[y_mrk]
		var moving_nodes = get_tree().get_nodes_in_group("movable")
		for i in moving_nodes:
			var tween = create_tween()
			tween.tween_property(i, "global_position", i.global_position - Vector2(0, dist), 0.3)
		solution_maker.offset -= Vector2(0, dist)
		await get_tree().create_timer(0.3).timeout
		not_moving = true
		y_mrk -= 1

func _on_down_pressed() -> void:
	if not_moving and y_mrk < 2:
		not_moving = false
		y_mrk += 1
		var dist = y_coords[y_mrk]
		var moving_nodes = get_tree().get_nodes_in_group("movable")
		for i in moving_nodes:
			var tween = create_tween()
			tween.tween_property(i, "global_position", i.global_position + Vector2(0, dist), 0.3)
		solution_maker.offset += Vector2(0, dist)
		await get_tree().create_timer(0.3).timeout
		not_moving = true
