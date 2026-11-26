extends Node2D

@onready var area_2d_2: Area2D = $Area2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.update_force("mouth")

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.update_force("none")


func _on_button_pressed() -> void:
	area_2d_2.monitoring = true
