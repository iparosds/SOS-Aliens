extends Node

var scene_manager: SceneManager
var level: Level
var ui: UI
var camera_2d: Camera2D

var total_patriotas_generated := 0
var max_patriotas_by_level := 0
var current_level_path: String

@onready var patriota = preload("res://scenes/patriota.tscn")

func change_level(load_level):
	var new_level = load(load_level).instantiate()
	
	if level:
		scene_manager.remove_child(level)
	
	scene_manager.add_child(new_level)
	level = new_level
	
	current_level_path = load_level

func start_level():
	randomize()
	total_patriotas_generated = 0
	max_patriotas_by_level = level.max_patriotas
	level.timer.start()
	level.spawn.start()
	ui.main_menu.visible = false
	ui.label.text = "Bom jogo!"
	camera_2d.reset_camera()

func restart_level():
	if current_level_path:
		change_level(current_level_path)
		start_level()
		camera_2d.reset_camera()

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

func game_over():
	print("game_over")
	level.visible = false
	level.timer.stop()
	ui.label.text = "Game Over"
	ui.main_menu.visible = true
	ui.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if ui.main_menu.visible:
		return
	
	if ui.is_paused:
		ui.hide_pause_menu()
	else:
		ui.show_pause_menu()

func back_to_main_menu():
	if level:
		level.queue_free()
		level = null
	
	ui.hide_pause_menu()
	get_tree().paused = false
	
	ui.main_menu.visible = true
	ui.label.text = "Bem-vindo de volta!"
	camera_2d.reset_camera()
