extends Node2D

@onready var starch_scene = preload("res://Nutrients/Starch.tscn")
@onready var proteins_scene = preload("res://Nutrients/Protein.tscn")
@onready var fats_scene = preload("res://Nutrients/Fats.tscn")
@onready var top_left: Marker2D = $Top_Left
@onready var bottom_right: Marker2D = $Bottom_Right

var nutrient_scene
var x
var y

@export var limit = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x = bottom_right.position.x
	y = bottom_right.position.y

func spawn_nutrients(scene : PackedScene):
	for i in limit:
		var nutrient = scene.instantiate()
		nutrient.global_position = Vector2(randf_range(-x, x), randf_range(-y, y))
		add_child(nutrient)
		await get_tree().create_timer(0.1).timeout

func _on_starch_button_pressed() -> void:
	spawn_nutrients(starch_scene)


func _on_protein_button_pressed() -> void:
	spawn_nutrients(proteins_scene)

func _on_fats_button_pressed() -> void:
	spawn_nutrients(fats_scene)
