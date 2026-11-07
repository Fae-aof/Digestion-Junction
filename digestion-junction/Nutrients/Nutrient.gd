extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var component_scene : PackedScene

@export var min_num : int
@export var max_num : int

@export var min_time : float = 1.5
@export var max_time : float = 4

var soft = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(0.9, 0.9)
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
