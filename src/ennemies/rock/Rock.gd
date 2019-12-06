extends KinematicBody2D

#export (PackedScene) var RockScene
onready var RockScene = load("res://src/ennemies/rock/Rock.tscn")
var rotation_speed = rand_range(50, 250)
var movement_speed = 100
var direction = Vector2()
var taille = 2
var has_been_init = false
var invulnerable = true

onready var screen_size = get_viewport().size

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_been_init == false:
		init(2)

func init(taille_param, position_param=null):
	taille = taille_param
	if taille == 2:
		var texture = randi() % 2
		if texture == 0:
			$Sprite.texture = load("res://src/assets/images/rocher48b.png")
		else:
			$Sprite.texture = load("res://src/assets/images/rocher48a.png")
		$CollisionShape2D.shape.extents = Vector2($Sprite.texture.get_width()/2, $Sprite.texture.get_height()/2)
	elif taille == 1:
		var texture = randi() % 2
		if texture == 0:
			$Sprite.texture = load("res://src/assets/images/rocher32b.png")
		else:
			$Sprite.texture = load("res://src/assets/images/rocher32a.png")
		$CollisionShape2D.shape.extents = Vector2($Sprite.texture.get_width()/2, $Sprite.texture.get_height()/2)
	else:
		var texture = randi() % 2
		if texture == 0:
			$Sprite.texture = load("res://src/assets/images/rocher16a.png")
		else:
			$Sprite.texture = load("res://src/assets/images/rocher16b.png")
		$CollisionShape2D.shape.extents = Vector2($Sprite.texture.get_width()/2, $Sprite.texture.get_height()/2)
	
	if position_param == null:
		var starting_pos = randi() % 2
		if starting_pos == 1:
			position.x = rand_range(-48, -24)
			position.y = rand_range(-48, -24)
		else:
			position.x = rand_range(screen_size.x + 24, screen_size.y + 48)
			position.y = rand_range(screen_size.x + 24, screen_size.y + 48)
	else:
		position = position_param
	
	direction.x = rand_range(0, 1)
	direction.y = rand_range(0 ,1)
	direction = direction.normalized()
	
	has_been_init = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = rotation_degrees + rotation_speed * delta
	
	var collision = move_and_collide(direction * movement_speed * delta)
	if collision != null && invulnerable == false:
		on_collision(collision)
		
	position.x = wrapf(position.x, -24, screen_size.x + 24)
	position.y = wrapf(position.y, -24, screen_size.y + 24)
		
func on_collision(collision):
	if collision.collider.name == "PlayerShip":
		var i = taille
		while i >= 1:
			var rock_instance = RockScene.instance()
			rock_instance.get_node("RockBody").init(taille - 1, position)
			get_parent().add_child(rock_instance)
			i -= 1
		queue_free()

func _on_Timer_timeout():
	invulnerable = false
