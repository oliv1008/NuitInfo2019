extends KinematicBody2D

var BulletScene = load("res://src/BaseProjectile/ProjectileAllié.tscn")

const TURN_SPEED = 180
const MOVE_SPEED = 150
var velocity = Vector2(0,0)
var applied_forces = Vector2()
const ACC = 0.05
const DEC = 0.01
var can_shoot = true
onready var screen_size = get_viewport().get_visible_rect().size


func _ready():
	pass
	
func _process(delta):
	screen_size = get_viewport().get_visible_rect().size
	if velocity.x == 0 && velocity.y == 0:
		$AnimationPlayer.play("idle")
	if Input.is_action_pressed("left"):
		rotation_degrees -= TURN_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation_degrees += TURN_SPEED * delta
		
	var movedir = Vector2(1,0).rotated(rotation)
	if Input.is_action_pressed("up"):
		velocity = velocity.linear_interpolate(movedir, ACC)
		$AnimationPlayer.play("REACTEUR NUCLEAIRE")
	else:
		velocity = velocity.linear_interpolate(Vector2(0,0), DEC)
		$AnimationPlayer.play("idle")

	var collision = move_and_collide(((velocity * MOVE_SPEED) + applied_forces) * delta)
	if collision != null:
		get_hit()
		
	applied_forces = Vector2(0, 0)
	position.x = wrapf(position.x, -8, screen_size.x + 8)
	position.y = wrapf(position.y, -8, screen_size.y + 8)
	
	if Input.is_action_pressed("shoot") && can_shoot == true:
		can_shoot = false
		shot(movedir)
		$Timer.start()
		
func get_hit():
	queue_free()
	get_tree().change_scene("res://src/Main/GameOver.tscn")
	
func shot(movedir):
	var bullet_instance = BulletScene.instance()
	bullet_instance.init(movedir, $Position2D.global_position, rotation_degrees)
	get_parent().add_child(bullet_instance)
	
	bullet_instance = BulletScene.instance()
	bullet_instance.init(movedir, $Position2D2.global_position, rotation_degrees)
	get_parent().add_child(bullet_instance)
	

func _on_Timer_timeout():
	can_shoot = true
