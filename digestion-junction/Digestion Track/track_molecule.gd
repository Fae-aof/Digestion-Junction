extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var bites_cap = 4

func shrink():
	if bites_cap > 0:
		var random = randi_range(1, 9)
		if random > 7:
			animation.scale = Vector2(0.09, 0.09)
			collision.scale = Vector2(0.09, 0.09)
			bites_cap = 0
		else:
			bites_cap -= 1
	else:
		var random = randi_range(1, 9)
		if random > 7:
			animation.scale = Vector2(0.09, 0.09)
			collision.scale = Vector2(0.09, 0.09)
			bites_cap = 0
