extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scl = randf_range(0.08, 0.13)
	animation.scale = Vector2(scl, scl)
	collision.scale = Vector2(scl, scl)
	apply_force(Vector2(10, 2))
