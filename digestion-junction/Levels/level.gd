extends CanvasLayer

@onready var label: Label = $Guide/MarginContainer/Label
@onready var margin_container: MarginContainer = $MarginContainer

@export_multiline var texts : Array[String]

var line = 0

func _ready() -> void:
	label.text = texts[line]
	
func _on_forward_pressed() -> void:
	line += 1
	line = clamp(line, 0, texts.size() - 1)
	label.text = texts[line]

func _on_back_pressed() -> void:
	line -= 1
	line = clamp(line, 0, texts.size())
	label.text = texts[line]


func _on_guide_button_pressed() -> void:
	margin_container.show()


func _on_close_pressed() -> void:
	margin_container.hide()
