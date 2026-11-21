extends Node2D

@onready var barrier_parent: StaticBody2D = $Barriers

var barriers = []

var mouth_ans = ["mucin", "water", "amylase", "lysozyme"]
var stomach_ans = ["rennin", "pepsin", "water", "mucin", "hydrochloric acid"]
var intestine_ans = ["maltase", "lactase", "protease", "lipase"]
var answers = [mouth_ans, stomach_ans, intestine_ans]
var current_ans

@onready var top_teeth: CollisionShape2D = $"Teeth/Top teeth"
@onready var bottom_teeth: CollisionShape2D = $"Teeth/Bottom teeth"
@onready var peri_1: Node2D = $Peri1
@onready var peri_2: Node2D = $Peri2
@onready var peri_3: Node2D = $Peri3

var peri_array 
var peri_count = 0

var score = 0

func _ready() -> void:
	peri_array = [peri_1, peri_2, peri_3]
	barriers = barrier_parent.get_children()
	current_ans = answers.pop_front()

func area_complete():
	current_ans = answers.pop_front()
	var bar = barriers.pop_front()
	bar.queue_free()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		move_teeth()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("small"):
		score += 1


func _on_teeth_body_entered(body: Node2D) -> void:
	if (body.is_in_group("small")):
		body.shrink()

func move_teeth():
	var y_cord = 74
	var mid_cord = 30
	var tweenT = create_tween()
	tweenT.tween_property(top_teeth, "position", Vector2 (0,-mid_cord), 0.15)
	var tweenB = create_tween()
	tweenB.tween_property(bottom_teeth, "position", Vector2 (0,mid_cord), 0.15)
	tweenT.tween_property(top_teeth, "position", Vector2 (0,-y_cord), 0.15)
	tweenB.tween_property(bottom_teeth, "position", Vector2 (0,y_cord), 0.15)


func _on_esoph_body_exited(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.gravity_scale = 0.01
		body.linear_velocity = Vector2.ZERO

func _on_friction_pressed() -> void:
	var peri = peri_array[peri_count]
	for i in peri.get_children():
		i.squeeze()
	peri_count += 1;
	if peri_count >= 3:
		peri_count = 0


func _on_esoph_exit_body_exited(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.gravity_scale = 1
