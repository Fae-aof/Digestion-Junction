extends CanvasLayer

@onready var pH_label: Label = $pH
@onready var solution: Sprite2D = $Solution
@onready var spawner: Node2D = $Spawner

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


func _on_fill_up_pressed() -> void:
	solution.fill_up()

func _on_reset_pressed() -> void:
	solution.empty()
	var all_molecules = spawner.get_children()
	for i in all_molecules:
		i.queue_free()


func _on_amylase_toggle_pressed() -> void:
	solution.add_solution("amylase")

func _on_protease_toggle_pressed() -> void:
	solution.add_solution("protease")

func _on_lipase_toggle_pressed() -> void:
	solution.add_solution("lipase")
