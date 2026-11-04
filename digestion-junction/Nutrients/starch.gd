extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var maltose_scene = preload("res://Nutrients/maltose.tscn")

var starch_length = randi_range(3, 5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("Starch")

func break_into_maltose():
	for i in starch_length:
		var maltose = maltose_scene.instantiate()
		get_parent().add_child.call_deferred(maltose)
		maltose.set_deferred("global_position", global_position + Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1)))
	queue_free()
