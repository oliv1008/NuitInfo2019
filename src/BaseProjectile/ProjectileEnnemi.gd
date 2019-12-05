extends KinematicBody2D

var velocity
var shooter
var damage
var playerPos
export (int) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	print("BITASSE")
	print("shooter = ", shooter)
	var shooterPos = shooter.position
	#rotation_degrees = angle + 90
	var targetPos = playerPos.normalized()
	print(targetPos)
	
	velocity = targetPos * speed 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collisionData = move_and_collide(velocity * delta)
	if collisionData != null:
		if collisionData.collider.get_class() == "KinematicBody2D":
			if collisionData.collider.has_method("get_hit"):
				collisionData.collider.get_hit()
				visible = false
				queue_free()
		else:
			queue_free()

func _on_Visibility_sreen_exited():
	queue_free()