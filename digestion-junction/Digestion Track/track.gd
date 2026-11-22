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
var teeth_count = 0
var teeth_moving = false

signal peri_start
@onready var peristalsis_parent: Marker2D = $"Peristalsis Parent"
@onready var peri_node = preload("res://Digestion Track/peristalsis_node.tscn")
var peri_ready = true
var cooldown = 0
var decay = 1

var score = 0

func _ready() -> void:
	peristalsis()
	barriers = barrier_parent.get_children()
	current_ans = answers.pop_front()

func area_complete():
	current_ans = answers.pop_front()
	var bar = barriers.pop_front()
	bar.queue_free()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		move_teeth()
	if decay > 0:
		peristalsis()
	decay -= delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("small"):
		score += 1


func _on_teeth_body_entered(body: Node2D) -> void:
	if (body.is_in_group("small")):
		body.shrink()

func move_teeth():
	if !teeth_moving:
		teeth_moving
		teeth_count += 1
		var y_cord = 74
		var mid_cord = 30
		var tweenT = create_tween()
		tweenT.tween_property(top_teeth, "position", Vector2 (0,-mid_cord), 0.15)
		var tweenB = create_tween()
		tweenB.tween_property(bottom_teeth, "position", Vector2 (0,mid_cord), 0.15)
		tweenT.tween_property(top_teeth, "position", Vector2 (0,-y_cord), 0.15)
		tweenB.tween_property(bottom_teeth, "position", Vector2 (0,y_cord), 0.15)
		if teeth_count > 4:
			emit_signal("peri_start")

func _on_esoph_body_exited(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.gravity_scale = 0.01
		body.linear_velocity = Vector2.ZERO

func _on_friction_pressed() -> void:
	peristalsis()

func _on_esoph_exit_body_exited(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.gravity_scale = 1

func peristalsis():
	if peri_ready:
		if cooldown == 0:
			var new_peri = peri_node.instantiate()
			peristalsis_parent.add_child(new_peri)
			cooldown = 3
		peri_ready = false
		for i in peristalsis_parent.get_children():
			i.move()
		cooldown -= 1
		await get_tree().create_timer(0.6).timeout
		peri_ready = true
