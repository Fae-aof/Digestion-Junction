extends CanvasLayer

@onready var solution_maker: CanvasLayer = $"Solution Maker"
@onready var camera: Camera2D = $Camera2D
@onready var mixed_scene = preload("res://Solution Making/mixed_solution.tscn")
@onready var solution_marker: Marker2D = $"Solution Marker"
@onready var label: RichTextLabel = $"Components List/MarginContainer/RichTextLabel"
@onready var spawner: Node2D = $Spawner
@onready var part_label: Label = $"Part Label"
@onready var track: Node2D = $"Track Spot/Track"
@onready var score: Label = $Score
@onready var components: GridContainer = $Answers2/MarginContainer/Components


var at_lab = false

@onready var prompt_title: Label = $"Prompts/MarginContainer/VBoxContainer/Prompt Title"
@onready var prompt_desc: Label = $"Prompts/MarginContainer/VBoxContainer/Prompt Desc"
var labels

@onready var push: Button = $Push

var y_coords = [0, 450, 315]
var y_mrk = 0

var answers
var correct = []
var done_count = 0

var not_moving = true

var sections = 0
var titles = ["Mix the correct solutions:", "Bite the food:", 
			"Push the food down the gullet:", "Mix the correct solutions:", "Push molecules and mix the solution:", "You Win!"]
var guide = ["The mouth produces saliva that destroys bacteria, breaks down starch and softens food.", "Press the down arrow key to break the molecules into smaller pieces.",
			"Click the yellow ball to activate peristalsis, movement that pushes the food down the gullet.",
			"The stomach produces acid that lowers the pH, pepsin, rennin and mucus.",
			"Use the ball to push molecules into the small intestine. The small intestine breaks down lactose, maltose, fats and proteins.",
			"Congradtulations! You completed Digestion Junction!"]

#Peristalsis
var peri_startable = false
var peri_ongoing = false
@onready var but_mark2: Marker2D = $"Game Panel/Marker2D"
@onready var but_mark: Marker2D = $"Game Panel/Marker2D2"
@onready var button: Button = $"Game Panel/Button"
@onready var game_panel: Panel = $"Game Panel"

#guide
@onready var guide_panel: MarginContainer = $"Solution Maker/MarginContainer"
@onready var close: Button = $"Solution Maker/Close"


func _process(delta: float) -> void:
	score.text = "Score: " + str(track.score)
	if sections > 0 and peri_startable:
		game_panel.show()
		peri_startable = false
	if peri_ongoing and track.bit_count < 4:
		update_prompt()
		game_panel.hide()
		track.decay = 35
		peri_ongoing = false
	
func _ready() -> void:
	labels = components.get_children()
	answers = track.current_ans
	update_prompt()
	track.connect("peri_start", peri_start)

func update_prompt():
	prompt_title.text = titles.pop_front()
	prompt_desc.text = guide.pop_front()

func _on_to_track_pressed() -> void:
	if at_lab:
		for i in labels:
			i.text = ""
			i.add_theme_color_override("font_color", Color("3c1902"))
		var count = 0
		for i in solution_maker.components:
			labels[count].text = i
			count += 1
		var tween = create_tween()
		tween.tween_property(camera, "global_position", camera.global_position + Vector2(1280, 0), 0.4)
		at_lab = false
	
func _on_to_lab_pressed() -> void:
	if !at_lab:
		var tween = create_tween()
		tween.tween_property(camera, "global_position", camera.global_position - Vector2(1280, 0), 0.4)
		at_lab = true

func _on_pour_solution_pressed() -> void:
	track.area_complete()
	sections += 1
	update_prompt()
	var incorrect = solution_maker.components.duplicate()
	for i in solution_maker.components:
		if answers.has(i):
			incorrect.erase(i)
			if !correct.has(i):
				correct.append(i)
				done_count += 1
	for i in labels:
		if correct.has(i.text):
			i.add_theme_color_override("font_color", Color("196b00"))
		else:
			i.add_theme_color_override("font_color", Color("8b0000"))
	if done_count == answers.size() and incorrect == []:
		track.area_complete()
		sections += 1
		update_prompt()
		answers = track.current_ans
		correct = []
		done_count = 0
	

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


func peri_start():
	update_prompt()
	peri_startable = true


func _on_guide_button_pressed() -> void:
	guide_panel.show()
	close.show()

func _on_close_pressed() -> void:
	guide_panel.hide()
	close.hide()


func _on_button_pressed() -> void:
	peri_ongoing = true
	button.global_position = Vector2(randf_range(but_mark.global_position.x, but_mark2.global_position.x), randf_range(but_mark.global_position.y, but_mark2.global_position.y))
	track.decay = 1.5


func _on_testing_pressed() -> void:
	track.testing()
