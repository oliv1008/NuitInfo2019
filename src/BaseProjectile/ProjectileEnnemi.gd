extends KinematicBody2D

var velocity
export (int) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
			
func init(movedir, position_param, rotation_degreess_param):
	global_position = position_param
	rotation_degrees = rotation_degreess_param
	velocity = movedir * speed

func _on_Visibility_sreen_exited():
	queue_free()