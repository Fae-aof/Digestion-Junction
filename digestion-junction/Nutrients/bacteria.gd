extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var min_time : float = 1.5
@export var max_time : float = 3


func _ready() -> void:
	animation.play("Molecule")
	
# Called when the node enters the scene tree for the first time.
func break_down():
	await get_tree().create_timer(randf_range(min_time, max_time)).timeout
	var decay_time = randf_range(1.5, 3.5)
	var tween = create_tween()
	tween.tween_property(animation, "modulate:a", 0.1, decay_time)
	await get_tree().create_timer(decay_time-0.5).timeout
	queue_free()
