extends Button

var on = false

func _process(delta: float) -> void:
	if on:
		global_position = get_global_mouse_position()

func _on_pressed() -> void:
	if on:
		on = false
	else:
		on = true
