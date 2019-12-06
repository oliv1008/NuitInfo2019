extends Node2D

var RockScene = load("res://src/ennemies/rock/Rock.tscn")
var AlienScene = load("res://src/ennemies/alien/Alien.tscn")
var BlackHoleScene = load("res://src/ennemies/blackhole/BlackHole.tscn")

onready var label = $Label
onready var LabelTimer = $Label2
var total_time = 0
var score = 0
var alien_one_shot = false
var BH_one_shot = false
onready var screen_size = get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	singleton.MainScreen = self
	add_score(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	###### ROCHER ######
	var rand_rock_difficulty = inverse_lerp(0, 150, total_time)
	var rand_rock = lerp(1, 4, rand_rock_difficulty)
	var rand_range_rock = rand_range(0, 1)
	if (rand_range_rock < 0.001 * rand_rock):
		spawn_rock()
		
	###### ALIEN ######
	var rand_alien_difficulty = inverse_lerp(0, 150, total_time)
	var rand_alien = lerp(1, 4, rand_alien_difficulty)
	var rand_range_alien = rand_range(0, 1)
	if (rand_range_alien < 0.0003 * rand_alien) && total_time >= 50 || (alien_one_shot == false && total_time >= 50):
		alien_one_shot = true
		spawn_alien()
	###### TROU NOIR ######
	var rand_BH_difficulty = inverse_lerp(0, 150, total_time)
	var rand_BH = lerp(1, 4, rand_BH_difficulty)
	var rand_range_BH = rand_range(0, 1)
	if (rand_range_BH < 0.0002 * rand_BH) && total_time >= 90 || (BH_one_shot == false && total_time >= 90):
		BH_one_shot = true
		spawn_BH()

func add_score(score_to_add):
	score += score_to_add
	label.text = "Score = " + String(score)
	
func spawn_rock():
	var taille
	var taille_rand = randi() % total_time
	if taille_rand >= 0 && taille_rand < 30:
		taille = 0
	elif taille_rand >= 30 && taille_rand < 60:
		taille = 1
	elif taille_rand >= 60:
		taille = 2
			
	var movement_speed_difficulty = inverse_lerp(0, 150, total_time)

	var movement_speed = lerp(60, 100, movement_speed_difficulty)
	movement_speed += rand_range(-20, 0)
	var rock_instance = RockScene.instance()
	rock_instance.get_node("RockBody").init(taille, movement_speed)
	add_child(rock_instance)	
	
func spawn_alien():
	var alien_instance = AlienScene.instance()
	add_child(alien_instance)	
	
func spawn_BH():
	var BH_instance = BlackHoleScene.instance()
	add_child(BH_instance)	
	
func _on_Timer_timeout():
	total_time += 1
	add_score(1)
	LabelTimer.text = "Temps : " + String(total_time)


func _on_Timer10_timeout():
	if total_time > 40 && total_time <= 60:
		spawn_rock()


func _on_Timer5_timeout():
	if total_time <= 40:
		spawn_rock()


func _on_Timer3_timeout():
	if total_time <= 30:
		spawn_rock()
