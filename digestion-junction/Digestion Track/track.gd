extends Node2D

@onready var bar1: StaticBody2D = $Container/StaticBody2D
@onready var bar2: StaticBody2D = $Container2/StaticBody2D

var barriers = []

var mouth_ans = ["mucin", "water", "amylase", "lysozyme"]
var stomach_ans = ["rennin", "pepsin", "water", "mucin", "hydrochloric acid"]

var answers = [mouth_ans, stomach_ans]
var current_ans

func _ready() -> void:
	barriers = [bar1, bar2]
	current_ans = answers.pop_front()

func area_complete():
	current_ans = answers.pop_front()
	var bar = barriers.pop_front()
	bar.queue_free()
	
