extends Node2D

export (String) var nameOfWeapon
export (float) var damageMultiplier
export (float) var rateOfFire
var canShot = true
export (PackedScene) var projectile
onready var holder = self

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = rateOfFire
	if get_parent().get_class() == "KinematicBody2D":
		holder = get_parent()
		print("Arme fille d'un kinematicBody, on initialise le porteur")

func _process(delta):
	pass

func shot(targetPos):
	if (canShot):
		var projectileInstance = projectile.instance()
		projectileInstance.mousePos = targetPos
		projectileInstance.damage = 10 * damageMultiplier
		projectileInstance.shooter = holder
		print("self = ", self)
		print("holder = ", holder)
		projectileInstance.position = $EndBarrel.global_position
		holder.get_parent().add_child(projectileInstance)
		canShot = false
		$Timer.start()

func _on_Timer_timeout():
	canShot = true
	$Timer.stop()
