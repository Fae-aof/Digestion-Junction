extends CanvasLayer

@onready var pH_label: Label = $pH
@onready var solution = preload("res://Solution Making/solution.tscn")
@onready var spawner: Node2D = $Spawner
@onready var solution_marker: Marker2D = $"Solution Marker"
@onready var flask_parent: Node2D = $Flasks

@onready var amylase_toggle: Button = $"Amylase Toggle"
@onready var protease_toggle: Button = $"Protease Toggle"
@onready var lipase_toggle: Button = $"Lipase Toggle"

@onready var enzyme_toggles = [amylase_toggle, protease_toggle, lipase_toggle]

@export var solutions_list: solution_list
@export var sprites_list: sprite_list
	
var pH = 7
var flasks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	solutions_list.names.shuffle()
	sprites_list.sprites.shuffle()
	flasks = flask_parent.get_children()
	var count = 0
	for i in flasks:
		i.connect("add_solution", flask_pressed)
		i.solution = solutions_list.names[count]
		var flask_sprite = i.get_node("Button")
		flask_sprite.icon = sprites_list.sprites[count]
		count += 1
		
	set_pH()

func set_pH():
	pH = clamp(pH, 0, 14)
	pH_label.text = "pH: " + str(pH)


func _on_increase_p_h_pressed() -> void:
	pH += 1
	set_pH()

func _on_decrease_p_h_pressed() -> void:
	pH -= 1
	set_pH()


func _on_drain_pressed() -> void:
	var solutions = solution_marker.get_children()
	for i in solutions:
		i.empty()
	for i in flasks:
		i.reset()

func _on_reset_pressed() -> void:
	var all_molecules = spawner.get_children()
	for i in all_molecules:
		i.queue_free()

func flask_pressed(solution_name : String):
	add_solution(solution_name)

func add_solution(solution_name : String):
	var new_solution = solution.instantiate()
	solution_marker.add_child(new_solution)
	new_solution.position = Vector2(0, 0)
	new_solution.fill_up(solution_name)
