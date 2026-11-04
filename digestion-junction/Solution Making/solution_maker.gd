extends CanvasLayer

@onready var pH_label: Label = $pH
@onready var solution = preload("res://Solution Making/solution.tscn")
@onready var spawner: Node2D = $Spawner
@onready var solution_marker: Marker2D = $"Solution Marker"

@onready var amylase_toggle: Button = $"Amylase Toggle"
@onready var protease_toggle: Button = $"Protease Toggle"
@onready var lipase_toggle: Button = $"Lipase Toggle"

@onready var enzyme_toggles = [amylase_toggle, protease_toggle, lipase_toggle]

var pH = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	for i in enzyme_toggles:
		i.disabled = false

func _on_reset_pressed() -> void:
	var all_molecules = spawner.get_children()
	for i in all_molecules:
		i.queue_free()


func _on_amylase_toggle_pressed() -> void:
	add_solution("amylase")
	amylase_toggle.disabled = true

func _on_protease_toggle_pressed() -> void:
	add_solution("protease")
	protease_toggle.disabled = true
	
func _on_lipase_toggle_pressed() -> void:
	add_solution("lipase")
	lipase_toggle.disabled = true

func add_solution(solution_name : String):
	var new_solution = solution.instantiate()
	solution_marker.add_child(new_solution)
	new_solution.position = Vector2(0, 0)
	new_solution.fill_up(solution_name)
