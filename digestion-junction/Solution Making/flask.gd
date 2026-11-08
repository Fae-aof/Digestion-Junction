extends Control

@onready var button: Button = $Button
@onready var flask_label: TextEdit = $Flask_Label
@onready var checkmark: Sprite2D = $Check

@onready var correct_stylebox = preload("res://Styleboxes/Text Input Correct.tres")

@export var solution : String
@export var colour : String

var correct = false

signal add_solution(solution_name : String)

func _on_button_pressed() -> void:
	add_solution.emit(solution, colour)
	button.disabled = true

func reset():
	button.disabled = false

func check():
	if flask_label.text == solution:
		correct = true
		flask_label.add_theme_stylebox_override("normal", correct_stylebox)
		flask_label.editable = false
		checkmark.show()
