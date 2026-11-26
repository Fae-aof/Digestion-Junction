extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var force_key = "none"
var force_dict = {"none" : Vector2(0, 0), "mouth" : Vector2(0.1, 0), "stomach" : Vector2(-0.55, -0.4)}

func _process(delta: float) -> void:
	apply_central_impulse(force_dict[force_key])

func update_force(key : String):
	force_key = key

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scl = randf_range(0.08, 0.13)
	animation.scale = Vector2(scl, scl)
	collision.scale = Vector2(scl, scl)
	apply_force(Vector2(10, 2))
