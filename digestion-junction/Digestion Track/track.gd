extends Node2D

@onready var barrier_parent: StaticBody2D = $Barriers

var barriers = []

var mouth_ans = ["mucin", "water", "amylase", "lysozyme"]
var stomach_ans = ["rennin", "pepsin", "water", "mucin", "hydrochloric acid"]
var intestine_ans = ["maltase", "lactase", "protease", "lipase"]
var answers = [mouth_ans, stomach_ans]
var current_ans

func _ready() -> void:
	position = Vector2(0, 500)
	barriers = barrier_parent.get_children()
	current_ans = answers.pop_front()

func area_complete():
	current_ans = answers.pop_front()
	var bar = barriers.pop_front()
	bar.queue_free()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.apply_central_force(Vector2(-350, 0))
