extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var too_big = true
var bites_cap = 4

func shrink():
	print(bites_cap)
	if bites_cap > 0:
		var random = randi_range(1, 9)
		print(random)
		if random > 7:
			var scl = randf_range(0.12, 0.16)
			animation.scale = Vector2(scl, scl)
			collision.scale = Vector2(scl, scl)
			bites_cap = -5
		else:
			bites_cap -= 1
	elif bites_cap == -5:
		pass
	else:
			var scl = randf_range(0.12, 0.16)
			animation.scale = Vector2(scl, scl)
			collision.scale = Vector2(scl, scl)
			bites_cap = -5
