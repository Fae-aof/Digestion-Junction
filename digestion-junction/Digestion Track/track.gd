extends Node2D

@onready var barrier_parent: StaticBody2D = $Barriers

var barriers = []

#barrier removal
var mouth_ans = ["mucin", "water", "amylase", "lysozyme"]
var stomach_ans = ["rennin", "pepsin", "water", "mucin", "hydrochloric acid"]
var intestine_ans = ["maltase", "lactase", "protease", "lipase"]
var answers = [mouth_ans, stomach_ans, intestine_ans]
var current_ans

#teeth
@onready var top_teeth: CollisionShape2D = $"Teeth/Top teeth"
@onready var bottom_teeth: CollisionShape2D = $"Teeth/Bottom teeth"
var teeth_count = 0
var teeth_moving = false

#peristalsis
signal peri_start
@onready var peristalsis_parent: Marker2D = $"Peristalsis Parent"
@onready var peri_node = preload("res://Digestion Track/peristalsis_node.tscn")
var peri_ready = true
var cooldown = 0
var decay = 1
var bit_count = 0

#Force
@onready var force_area_parent: Node2D = $"Force Areas"
@onready var force_areas = force_area_parent.get_children()

#intestion peristalsis
var intestine_peri = false
#@onready var intesetine_peri_parent: Node2D = $"Intesetine Peri Parent"
var intestines = []
@onready var intesetine_peri_parent: Node2D = $"Intesetine Peri Parent2"


var score = 0

func _ready() -> void:
	#peristalsis()
	barriers = barrier_parent.get_children()
	current_ans = answers.pop_front()
	intestine_peri = true
	intestines = intesetine_peri_parent.get_children()
	
	#force
	for i in force_areas:
		i.body_entered.connect(force_entered.bind(i))
		i.body_exited.connect(force_exited.bind(i))

func area_complete():
	current_ans = answers.pop_front()
	var bar = barriers.pop_front()
	bar.queue_free()
	force_areas.pop_front().monitoring = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		move_teeth()
	if decay > 0:
		peristalsis()
	#decay -= delta
	#if intestine_peri:
		#for i in intestines:
			#var follow = i.get_node("Intestine Path")
			#follow.progress += 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bit"):
		body.gravity_scale = 1
		body.in_intestine = false
		body.destroy()
		score += 1

func _on_teeth_body_entered(body: Node2D) -> void:
	if (body.is_in_group("small")):
		body.shrink()

func move_teeth():
	if !teeth_moving and current_ans != mouth_ans:
		teeth_moving = true
		teeth_count += 1
		var y_cord = 74
		var mid_cord = 30
		#var tweenT = create_tween()
		#tweenT.tween_property(top_teeth, "position", Vector2 (0,-mid_cord), 0.15)
		var tweenB = create_tween()
		tweenB.tween_property(bottom_teeth, "position", Vector2 (0,-19), 0.15)
		#tweenT.tween_property(top_teeth, "position", Vector2 (0,-y_cord), 0.15)
		tweenB.tween_property(bottom_teeth, "position", Vector2 (0,y_cord), 0.15)
		if teeth_count == 5:
			emit_signal("peri_start")
		await get_tree().create_timer(0.3)
		teeth_moving = false

func _on_esoph_body_exited(body: Node2D) -> void:
	if body.is_in_group("small"):
		body.gravity_scale = 0.01
		body.linear_velocity = Vector2.ZERO

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
		await get_tree().create_timer(0.5).timeout
		peri_ready = true

func _on_esophagus_body_entered(body: Node2D) -> void:
	print(body.get_groups())
	if body.is_in_group("bit"):
		bit_count += 1


func _on_esophagus_body_exited(body: Node2D) -> void:
	if body.is_in_group("bit"):
		bit_count -= 1

func force_entered(body: Node2D, area : Area2D):
	if body.is_in_group("bit"):
		print(area.get_meta("force_loc"))
		body.update_force(area.get_meta("force_loc"))
	
func force_exited(body: Node2D, area : Area2D):
	if body.is_in_group("bit"):
		body.update_force("none")

func testing():
	intestine_peri = true


func _on_stomach_exit_body_exited(body: Node2D) -> void:
	if body.is_in_group("bit"):
		body.update_force("none")
		body.in_intestine = true
		body.gravity_scale = 0


func _on_small_intestine_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("bit"):
		body.in_intestine = true
		body.enter_big()
