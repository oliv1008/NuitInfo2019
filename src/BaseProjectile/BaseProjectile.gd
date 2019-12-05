extends KinematicBody2D

var velocity
var shooter
var damage
var mousePos
export (int) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	print("shooter = ", shooter)
	var shooterPos = shooter.position
	var targetPos = (mousePos - shooterPos).normalized()
	velocity = targetPos * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collisionData = move_and_collide(velocity * delta)
	if collisionData != null:
		if collisionData.collider.get_class() == "KinematicBody2D":
			if collisionData.collider.has_method("get_hit"):
				collisionData.collider.get_hit(damage)
				visible = false
				queue_free()
		else:
			queue_free()

func _on_Visibility_sreen_exited():
	queue_free()