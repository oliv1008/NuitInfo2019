extends Node2D

var MAX_PULL_FORCE = 100
var player
var apply_forces = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if apply_forces:
		var pull_force = inverse_lerp(250, 0, $Sprite.global_position.distance_to(player.position))
		var distance_to = ($Area2D.global_position - player.global_position).normalized()
		var velocity_to_add = distance_to * (pull_force * MAX_PULL_FORCE)
		print("pull_force = ", pull_force)
		print("velocity_to_add = ", velocity_to_add)
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
