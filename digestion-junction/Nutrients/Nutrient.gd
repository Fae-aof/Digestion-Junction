extends RigidBody2D

var fats_scene

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var component_scene : PackedScene
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var min_num : int
@export var max_num : int

@export var min_time : float = 1.5
@export var max_time : float = 4

var emulsified = false

var soft = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fats_scene = load("res://Nutrients/Fats.tscn")
	animation.play("Molecule")

func break_down():
	var time = randf_range(min_time, max_time)
	if soft:
		time = time/3
	var number = randi_range(min_num, max_num)
	await get_tree().create_timer(time).timeout
	for i in number:
		var component = component_scene.instantiate()
		get_parent().add_child.call_deferred(component)
		component.set_deferred("global_position", global_position + Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1)))
	queue_free()

func emulsify():
	if !emulsified:
		var time = randf_range(min_time, max_time)
		if soft:
			time = time/3
		var number = randi_range(2, 3)
		await get_tree().create_timer(time).timeout
		emulsified = true
		for i in 2:
			call_deferred("spawn_fat", global_position)

func spawn_fat(position: Vector2):
	var fats = fats_scene.instantiate()
	fats.emulsified = true
	get_parent().add_child(fats)
	fats.set_deferred("global_position", global_position + Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1)))
	fats.shrink()
	queue_free()

func shrink():
	var sz = 0.33
	min_time = 1
	max_time = 2.5
	min_num = 1
	animation.scale = Vector2(sz, sz)
	collision.scale = Vector2(sz, sz)
