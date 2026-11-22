extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var bit_scene = preload("res://Digestion Track/Bit Molecule.tscn")

var too_big = true
var bites_cap = 4

func shrink():
	if bites_cap > 0:
		var random = randi_range(1, 9)
		if random > 7:
			for i in randi_range(2, 3):
				var mol = bit_scene.instantiate()
				mol.set_deferred("global_position", global_position) 
				get_parent().add_child(mol)
			queue_free()
		else:
			bites_cap -= 1
	else:
		for i in randi_range(2, 3):
			var mol = bit_scene.instantiate()
			mol.set_deferred("global_position", global_position) 
			get_parent().add_child(mol)
		queue_free()
	
	






	#if bites_cap > 0:
		#var random = randi_range(1, 9)
		#if random > 7:
			#var scl = randf_range(0.12, 0.16)
			#animation.scale = Vector2(scl, scl)
			#collision.scale = Vector2(scl, scl)
			#bites_cap = -5
			#set_collision_layer_value(2, false)
			#set_collision_mask_value(2, false)
			#apply_force(Vector2(10, 2))
		#else:
			#bites_cap -= 1
	#elif bites_cap == -5:
		#pass
	#else:
			#var scl = randf_range(0.12, 0.16)
			#animation.scale = Vector2(scl, scl)
			#collision.scale = Vector2(scl, scl)
			#bites_cap = -5
			#set_collision_layer_value(2, false)
			#set_collision_mask_value(2, false)
			#apply_force(Vector2(10, 2))
