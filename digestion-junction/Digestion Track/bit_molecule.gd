extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
#@onready var small_path: Path2D = $"../../Track/Intesetine Peri Parent3/Path2D"
#@onready var large_path: Path2D = $"../../Track/Intesetine Peri Parent3/Path2D2"
@onready var small_path: Path2D = $"../../Intesetine Peri Parent2/Path2D"
@onready var large_path: Path2D = $"../../Intesetine Peri Parent2/Path2D2"

#small intestine
var force_SI = 15
var look_forward = 5
var in_intestine = false
var path_2d

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
	path_2d = small_path
	in_intestine = true
	gravity_scale = 0

func _physics_process(delta: float) -> void:
	if in_intestine:
		var local_pos = path_2d.to_local(global_position)
		var current_offset = path_2d.curve.get_closest_offset(local_pos)
		var target_offset = min(current_offset + look_forward, path_2d.curve.get_baked_length())
		
		var target_global_pos = path_2d.to_global(path_2d.curve.sample_baked(target_offset))
		var direction = global_position.direction_to(target_global_pos)
		apply_central_force(direction * force_SI)

func enter_big():
	path_2d = large_path
	set_collision_layer_value(3, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(3, true)
	set_collision_mask_value(1, false)
	
func destroy():
	await get_tree().create_timer(0.5).timeout
	queue_free()
