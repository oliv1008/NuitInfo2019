extends Node2D

var MAX_PULL_FORCE = 125
var player
var apply_forces = false
var to_position = null

onready var screen_size = get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	$AnimationPlayer.play("Spawn")
	
	if to_position == null:
		position.x = rand_range(32, screen_size.x - 32)
		position.y = rand_range(32, screen_size.y - 32)
	else:
		position = to_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if apply_forces:
		var pull_force = inverse_lerp($Area2D/CollisionShape2D.shape.radius, 0, $Sprite.global_position.distance_to(player.position))
		var distance_to = ($Area2D.global_position - player.global_position).normalized()
		var velocity_to_add = distance_to * (pull_force * MAX_PULL_FORCE)
		player.applied_forces += velocity_to_add

func _on_Area2D_body_entered(body):
	if body.name == "PlayerShip":
		player = body
		apply_forces = true

func _on_Area2D_body_exited(body):
	if body == player:
		apply_forces = false
		
func die():
	apply_forces = false
	$AnimationPlayer.play("Die")
	
func on_die_finished():
	queue_free()
	
func on_spawn_finished():
	$AnimationPlayer.play("Idle")

func _on_Timer_timeout():
	die()


func _on_BlackHoleBody2D_body_entered(body):
	if body.name == "PlayerShip":
		if body.has_method("get_hit"):
			body.get_hit()
