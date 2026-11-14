extends CanvasLayer

@onready var solution = preload("res://Solution Making/solution.tscn")
@onready var spawner: Node2D = $Spawner
@onready var solution_marker: Marker2D = $"Solution Marker"
@onready var flask_parent: GridContainer = $Flasks
@onready var universal_indicator: Area2D = $"Universal Indicator"
@onready var pH_button: Button = $"pH button"
@onready var next_level: Button = $"Next Level"
@onready var flask_scene = preload("res://Solution Making/flask.tscn")

@onready var lactose_scene = preload("res://Nutrients/Lactose.tscn")
@onready var casein_scene = preload("res://Nutrients/Casein.tscn")
@onready var milk_marker: Marker2D = $Milk/Marker2D

@export var level_scene : String
@export var solutions_list: solution_list
@export var sprites_list: sprite_list
@export var flask_count : int

@export var cheats = false
@export var disable_pH = false

var flasks
var components =  []

var pH = null
var pH_solutions_dict = {"hydrochloric acid": 2, "sodium hydrogen carbonate": 8, "water" : 7}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if disable_pH:
		universal_indicator.hide()
		pH_button.hide()
	for i in flask_count:
		var new_flask = flask_scene.instantiate()
		flask_parent.add_child(new_flask)
	solutions_list.names.shuffle()
	sprites_list.numbers.shuffle()
	flasks = flask_parent.get_children()
	var count = 0
	for i in flasks:
		var random_count = sprites_list.numbers[count]
		i.connect("add_solution", flask_pressed)
		i.solution = solutions_list.names[count]
		var flask_sprite = i.get_node("Button")
		flask_sprite.icon = sprites_list.sprites[random_count]
		i.colour = sprites_list.colours[random_count]
		var flask_label = i.get_node("Flask_Label")
		if cheats:
			flask_label.text = solutions_list.names[count]
		count += 1
		

func _on_drain_pressed() -> void:
	var solutions = solution_marker.get_children()
	for i in solutions:
		i.empty()
	for i in flasks:
		i.reset()
	pH = null
	components = []
	spawner.mucus_added = false


func _on_reset_pressed() -> void:
	var all_molecules = spawner.get_children()
	for i in all_molecules:
		i.queue_free()
	for i in $Casein.get_children():
		i.queue_free()

func flask_pressed(solution_name : String, colour : String):
	add_solution(solution_name, colour)
	components.append(solution_name)
	if components.has("water") and components.has("mucin"):
		var all_molecules = spawner.get_children()
		spawner.mucus_added = true
		for i in all_molecules:
			i.soft = true
	if pH_solutions_dict.has(solution_name):
		change_pH(pH_solutions_dict[solution_name])
	elif pH == null:
		pH = 7

func add_solution(solution_name : String, colour : String):
	var new_solution = solution.instantiate()
	solution_marker.add_child(new_solution)
	new_solution.position = Vector2(0, 0)
	new_solution.fill_up(solution_name, colour)

func change_pH(added_pH : int):
	if pH != null:
		pH = (pH + added_pH)/2
	else:
		pH = added_pH

func _on_p_h_button_pressed() -> void:
	if pH != null:
		universal_indicator.move_down(pH)
	else:
		universal_indicator.move()
	

func _on_check_pressed() -> void:
	var all_check = []
	for i in flasks:
		i.check()
		all_check.append(i.correct)
	if !all_check.has(false):
		next_level.show()


func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file(level_scene)


func _on_water_pressed() -> void:
	add_solution("water", "7cb8fb48")
	components.append("water")
	if components.has("water") and components.has("mucin"):
		var all_molecules = spawner.get_children()
		spawner.mucus_added = true
		for i in all_molecules:
			i.soft = true
	change_pH(7)
	
func _on_milk_pressed() -> void:
	add_solution("milk", "ffffff70")
	components.append("milk")
	for i in 8:
		var nutrient = lactose_scene.instantiate()
		nutrient.global_position = milk_marker.global_position + Vector2(randf_range(-20, 20), randf_range(0, 20))
		add_child(nutrient)
		var casein = casein_scene.instantiate()
		casein.global_position = milk_marker.global_position + Vector2(randf_range(-20, 20), randf_range(0, 20))
		if spawner.mucus_added == true:
			nutrient.soft = true
			casein.soft = true
		add_child(casein)
		await get_tree().create_timer(0.1).timeout
	change_pH(7)
