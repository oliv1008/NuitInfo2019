extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init(taille, position_param):
	position = position_param
	
	if taille == 1:
		scale = Vector2(2, 2)
	elif taille == 2:
		scale = Vector2(2.5, 2.5)
		
func on_Idle_finished():
	queue_free()