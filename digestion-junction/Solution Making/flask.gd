extends Control

@onready var button: Button = $Button

@export var solution : String
@export var colour : String

signal add_solution(solution_name : String)

func _on_button_pressed() -> void:
	add_solution.emit(solution, colour)
	button.disabled = true

func reset():
	button.disabled = false
