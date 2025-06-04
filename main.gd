extends Node

@export var mob_scene: PackedScene
var score
var high_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_high_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale_difficulty()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$BGMusic.stop()
	$DeathSound.play()
	if score > high_score:
		high_score = score
		save_high_score(high_score)
		$HUD.show_high_score(true)

	$HUD.update_high_score(high_score)
	
func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD.show_high_score(false)
	get_tree().call_group("mobs", "queue_free")
	$BGMusic.play()

func save_high_score(high_score_temp: int) -> void:
	var file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	if file:
		file.store_line(str(high_score_temp))
		file.close()

func load_high_score() -> void:
	var file = FileAccess.open("user://high_score.save", FileAccess.READ)
	if file:
		var line = file.get_line()
		print("High Score Line: ", line)
		if line:
			high_score = int(line)
		file.close()
	else:
		high_score = 0
	$HUD.update_high_score(high_score)

func scale_difficulty() -> void:
	if !score:
		return

	
	if score > 20:
		$MobTimer.wait_time = 0.75
	elif score > 50:
		$MobTimer.wait_time = 0.5
	elif score > 100:
		$MobTimer.wait_time = 0.35
	elif score > 200:
		$MobTimer.wait_time = 0.25
	elif score > 300:
		$MobTimer.wait_time = 0.2
	elif score > 500:
		$MobTimer.wait_time = 0.15

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
