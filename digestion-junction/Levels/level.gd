extends CanvasLayer

@onready var label: Label = $Guide/MarginContainer/Label

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
