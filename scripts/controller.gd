extends Node

var scene_manager: SceneManager
var level: Level
var ui: UI
var camera_2d: Camera2D
@onready var patriota = preload("res://scenes/patriota.tscn")

var total_patriotas_generated := 0
var max_patriotas_by_level := 0

func change_level(load_level):
	var new_level = load(load_level).instantiate()
	scene_manager.remove_child(level)
	scene_manager.add_child(new_level)

func start_level():
	randomize()
	total_patriotas_generated = 0
	max_patriotas_by_level = level.max_patriotas
	level.timer.start()
	level.spawn.start()
	ui.main_menu.visible = false
	ui.label.text = "Bom jogo!"
	camera_2d.reset_camera()

func spawn_patriota():
	if total_patriotas_generated >= max_patriotas_by_level:
		level.spawn.stop()
		return
	
	var entradas = level.entradas_labirinto.get_children()
	if entradas.size() == 0:
		print("⚠Nenhuma entrada encontrada")
		return
	
	var entrada_random = entradas[randi() % entradas.size()]
	
	var new_patriota = patriota.instantiate()
	new_patriota.saida = level.saida_labirinto.global_position
	new_patriota.global_position = entrada_random.global_position
	
	level.add_child(new_patriota)
	total_patriotas_generated += 1


func game_over():
	print("game_over")
	level.visible = false
	level.timer.stop()
	ui.label.text = "Game Over"
	ui.main_menu.visible = true
	ui.visible = true
