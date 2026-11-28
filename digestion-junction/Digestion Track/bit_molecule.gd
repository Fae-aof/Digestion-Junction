extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var path_2d: Path2D = $"../../Intesetine Peri Parent2/Path2D"

#small intestine
var force_SI = 20
var look_forward = 5

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

func _physics_process(delta: float) -> void:
	var local_pos = path_2d.to_local(global_position)
	var current_offset = path_2d.curve.get_closest_offset(local_pos)
	var target_offset = min(current_offset + look_forward, path_2d.curve.get_baked_length())
	
	var target_global_pos = path_2d.to_global(path_2d.curve.sample_baked(target_offset))
	var direction = global_position.direction_to(target_global_pos)
	apply_central_force(direction * force_SI)
