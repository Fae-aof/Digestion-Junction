extends Node2D

@onready var top_left: Marker2D = $Top_Left
@onready var bottom_right: Marker2D = $Bottom_Right
@export var molecule_list : molecule_List 
var nutrient_scene
var x
var y

var dict

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x = bottom_right.position.x
	y = bottom_right.position.y
	bottom_right.queue_free()
	top_left.queue_free()
	dict = molecule_list.molecule_dict
	for i in dict:
		for h in dict[i]:
			var nutrient = i.instantiate()
			nutrient.global_position = Vector2(randf_range(-x, x), randf_range(-y, y))
			nutrient.min_time += 15
			nutrient.max_time += 25
			add_child(nutrient)


func _process(delta: float) -> void:
	time += delta
	if time > 5:
		for i in 3:
			var slot = randi_range(0, 4)
			for h in randi_range(0, dict.values()[slot]):
				var nutrient = dict.keys()[slot].instantiate()
				nutrient.global_position = Vector2(randf_range(-x, x), randf_range(-y, y))
				nutrient.min_time += 15
				nutrient.max_time += 25
				add_child(nutrient)
		time = 0
