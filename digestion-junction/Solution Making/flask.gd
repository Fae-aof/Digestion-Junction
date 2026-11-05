extends Control

@onready var button: Button = $Button

@export var solution : String

signal add_solution(solution_name : String)

func _on_button_pressed() -> void:
	add_solution.emit(solution)
	button.disabled = true

func reset():
	button.disabled = false
