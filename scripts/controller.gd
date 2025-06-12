extends Node

var scene_manager: SceneManager
var level: Level
var ui: UI
var camera_2d: Camera2D
var total_patriotas_generated := 0
var max_patriotas_by_level := 0
var current_level: String
var current_level_path: String
var current_score := 0
var high_scores: Dictionary = {}

@onready var patriota = preload("res://scenes/patriota.tscn")
@onready var particle = preload("res://scenes/DeathParticlesRayExplosion.tscn")


var levels: Dictionary = {
	"level01" : {
		"label": "Rio de Janeiro",
		"url": "level_01.tscn",
		"unblock": "_level01",
	},
	"level02" : {
		"label": "Campinas",
		"url": "level_02.tscn",
		"unblock": "_level02",
	},
	"level03" : {
		"label": "Fortaleza",
		"url": "level_03.tscn",
		"unblock": "_level03",
	}
}


func _level01() -> bool:
	return true


func _level02() -> bool:
	return high_scores.get("level01", 0) >= 5


func _level03() -> bool:
	return high_scores.get("level02", 0) >= 10


func _ready():
	load_high_scores()


func is_unlocked(level_id: String) -> bool:
	var level_data = levels.get(level_id, 0)
	if level_data and has_method(level_data["unblock"]):
		return call(level_data["unblock"])
	return false


func start_level():
	randomize()
	total_patriotas_generated = 0
	max_patriotas_by_level = level.max_patriotas
	level.timer.start()
	level.spawn.start()
	ui.main_menu.visible = false
	ui.label.text = "Bom jogo!"
	camera_2d.reset_camera()
	
	current_score = 0
	ui.update_score(current_score)


func restart_level():
	if current_level_path:
		change_level(current_level_path)
		start_level()
		camera_2d.reset_camera()


func change_level(load_level):
	var level_path = "res://levels/" + load_level
	var new_level = load(level_path).instantiate()
	
	if level:
		scene_manager.remove_child(level)
	
	scene_manager.add_child(new_level)
	level = new_level
	
	for level_id in levels:
		if levels[level_id]["url"] == load_level:
			current_level = level_id
			break

	current_level_path = level_path
	load_high_scores()
	update_high_score()
	ui._generate_level_buttons()


func spawn_patriota():
	if total_patriotas_generated >= max_patriotas_by_level:
		level.spawn.stop()
		return
	
	var entradas = level.entradas_labirinto.get_children()
	var saidas = level.saidas_labirinto.get_children()
	var entrada_random = entradas[randi() % entradas.size()]
	var saida_random = saidas[randi() % saidas.size()]
	
	var new_patriota = patriota.instantiate()
	new_patriota.global_position = entrada_random.global_position
	new_patriota.saida = saida_random.global_position
	
	level.add_child(new_patriota)
	total_patriotas_generated += 1


func add_point():
	current_score += 1
	ui.update_score(current_score)


func game_over():
	print("game_over")
	level.visible = false
	level.timer.stop()
	
	ui.label.text = "Game Over"
	ui.pause_menu.visible = false
	ui.main_menu.visible = false
	ui.game_over_menu.visible = true
	get_tree().paused = false
	
	update_high_score()
	ui._generate_level_buttons()



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var click_position = get_viewport().get_camera_2d().get_global_mouse_position()
			
			# Dispara o som do tiro
			if ui:
				scene_manager.ray_shot.play()
			
			# Instancia explosão onde o jogador clicou
			var new_particle = particle.instantiate()
			new_particle.global_position = click_position
			new_particle.emitting = true
			get_tree().current_scene.add_child(new_particle)


func toggle_pause():
	if ui.main_menu.visible || ui.game_over_menu.visible:
		return
	
	if ui.is_paused:
		ui.hide_pause_menu()
	else:
		ui.show_pause_menu()


func back_to_main_menu():
	if level:
		update_high_score()
		level.queue_free()
		level = null
	
	ui.hide_pause_menu()
	get_tree().paused = false
	
	ui.main_menu.visible = true
	ui.label.text = "Bem-vindo de volta!"
	camera_2d.reset_camera()
	update_high_score()
	ui._generate_level_buttons()


func load_high_scores():
	if FileAccess.file_exists("user://high_scores.save"):
		var file = FileAccess.open("user://high_scores.save", FileAccess.READ)
		high_scores = file.get_var()


func update_high_score():
	var level_id = current_level.get_basename()
	if not high_scores.has(level_id):
		high_scores[level_id] = 0

	if current_score > high_scores[level_id]:
		high_scores[level_id] = current_score
		var file = FileAccess.open("user://high_scores.save", FileAccess.WRITE)
		file.store_var(high_scores)
