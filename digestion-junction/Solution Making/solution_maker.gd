extends CanvasLayer

@onready var pH_label: Label = $pH

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
