extends Button

@onready var margin_container: MarginContainer = $MarginContainer


func _on_pressed() -> void:
	margin_container.show()

func _on_close_pressed() -> void:
	pass # Replace with function body.
