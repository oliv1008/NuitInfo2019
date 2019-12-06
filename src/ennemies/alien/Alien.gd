extends KinematicBody2D

var BulletScene = load("res://src/BaseProjectile/ProjectileEnnemi.tscn")

var mouvementSpeed = 20
var currentPos = Vector2()
var playerPos = Vector2()
var velocity = Vector2()
var posToMove = Vector2()
var can_shoot = true
var player = false
var to_position = null

onready var screen_size = get_viewport().get_visible_rect().size

onready var Hitbox = $CollisionShape2D

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	if to_position == null:
		var starting_pos = randi() % 2
		if starting_pos == 1:
			position.x = rand_range(-48, -24)
			position.y = rand_range(-48, -24)
		else:
			position.x = rand_range(screen_size.x + 24, screen_size.y + 48)
			position.y = rand_range(screen_size.x + 24, screen_size.y + 48)
	else:
		position = to_position

func _physics_process(delta):
	currentPos = position
	move_and_slide(velocity, Vector2(0, -1))
	if (get_parent().get_node("PlayerShip")):
		playerPos = get_parent().get_node("PlayerShip").position
		posToMove = playerPos - currentPos
		look_at(playerPos)
		velocity = posToMove.normalized() * mouvementSpeed
		move_and_collide(velocity*delta)
		var movedir = Vector2(1, 0).rotated(rotation)
		if can_shoot:
			shot(movedir)
			can_shoot = false
			$Timer.start()
	
func get_hit():
	singleton.MainScreen.add_score(4)
	die()

func attack():
	var animationPlayer = $AnimationPlayer
	animationPlayer.play("attack")
	
func die():
	queue_free()
	
func shot(movedir):
	var bullet_instance = BulletScene.instance()
	bullet_instance.init(movedir, $Position2D.global_position, rotation_degrees)
	get_parent().add_child(bullet_instance)

func _on_Timer_timeout():
	can_shoot = true
