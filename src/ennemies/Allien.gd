extends KinematicBody2D

export (int) var pv = 5
var mouvementSpeed = 20
var currentPos = Vector2()
var playerPos = Vector2()
var velocity = Vector2()
var posToMove = Vector2()
var player = false

onready var Hitbox = $CollisionShape2D


func _ready():
	pass

func _physics_process(delta):
	currentPos = position
	move_and_slide(velocity, Vector2(0, -1))
	if (get_parent().get_node("PlayerShip")):
		playerPos = get_parent().get_node("PlayerShip").position
		posToMove = playerPos - currentPos
		look_at(playerPos)
		velocity = posToMove.normalized() * mouvementSpeed
		move_and_collide(velocity*delta)
		$Weapon.shot(playerPos)
	

	if pv <= 0:
		die()
	
func get_hit(degats):
	pv -= degats

func attack():
	var animationPlayer = $AnimationPlayer
	animationPlayer.play("attack")
	
func die():
	queue_free()





