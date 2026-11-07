extends CanvasLayer

@onready var solution = preload("res://Solution Making/solution.tscn")
@onready var spawner: Node2D = $Spawner
@onready var solution_marker: Marker2D = $"Solution Marker"
@onready var flask_parent: Node2D = $Flasks
@onready var universal_indicator: Area2D = $"Universal Indicator"

@onready var amylase_toggle: Button = $"Amylase Toggle"
@onready var protease_toggle: Button = $"Protease Toggle"
@onready var lipase_toggle: Button = $"Lipase Toggle"

@onready var enzyme_toggles = [amylase_toggle, protease_toggle, lipase_toggle]

@export var solutions_list: solution_list
@export var sprites_list: sprite_list
	
var flasks
var components =  []

var pH = null
var pH_solutions_dict = {"hydrochloric acid": 2, "sodium hydrogen carbonate": 8, "water" : 7}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	
