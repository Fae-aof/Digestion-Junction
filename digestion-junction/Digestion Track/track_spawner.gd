extends Node2D

@onready var top_left: Marker2D = $Top_Left
@onready var bottom_right: Marker2D = $Bottom_Right
@export var molecule_list : molecule_List 
var nutrient_scene
var x
var y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x = bottom_right.position.x
	y = bottom_right.position.y
	bottom_right.queue_free()
	top_left.queue_free()
	var dict = molecule_list.molecule_dict
	for i in dict:
		for h in dict[i]:
			var nutrient = i.instantiate()
			nutrient.global_position = Vector2(randf_range(-x, x), randf_range(-y, y))
			
			add_child(nutrient)
			await get_tree().create_timer(0.08).timeout
