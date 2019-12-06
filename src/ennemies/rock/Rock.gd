extends KinematicBody2D

onready var RockScene = load("res://src/ennemies/rock/Rock.tscn")
onready var ExplosionScene = load("res://src/Explosion/ExplosionAnim.tscn")

var rotation_speed = rand_range(50, 250)
var movement_speed
var direction = Vector2()
var taille = 2
var has_been_init = false
var to_position = null

onready var screen_size = get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_been_init == false:
		init(2, 100)
		
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

func init(taille_param, movement_speed_param, position_param=null):
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
	
	if position_param != null:
		to_position = position_param
	
	direction.x = rand_range(-1, 1)
	direction.y = rand_range(-1 ,1)
	direction = direction.normalized()
	
	movement_speed = movement_speed_param
	
	has_been_init = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	screen_size = get_viewport().get_visible_rect().size
	rotation_degrees = rotation_degrees + rotation_speed * delta
	
	var collision = move_and_collide(direction * movement_speed * delta)
	if collision != null:
		on_collision(collision.collider)
		
	position.x = wrapf(position.x, -24, screen_size.x + 24)
	position.y = wrapf(position.y, -24, screen_size.y + 24)
		
func on_collision(collider):
	if collider.name == "PlayerShip":
		if collider.has_method("get_hit"):
			collider.get_hit()
		
func get_hit():
	var i = taille
	while i >= 1:
		var rock_instance = RockScene.instance()
		rock_instance.get_node("RockBody").init(taille - 1, movement_speed, global_position)
		get_parent().add_child(rock_instance)
		i -= 1
	var explosion_instance = ExplosionScene.instance()
	explosion_instance.init(taille, global_position)
	get_parent().add_child(explosion_instance)
	singleton.MainScreen.add_score(taille + 1)
	queue_free()
