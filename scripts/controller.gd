extends Node

var scene_manager: SceneManager
var level: Level
var ui: UI
@onready var patriota = preload("res://scenes/patriota.tscn")

func change_level(load_level):
	var new_level = load(load_level).instantiate()
	scene_manager.remove_child(level)
	scene_manager.add_child(new_level)

func start_level():
	level.timer.start()
	level.spawn.start()
	ui.main_menu.visible = false
	ui.label.text = "Bom jogo!"

func spawn_patriota():
	var new_patriota = patriota.instantiate()
	new_patriota.saida  = level.saida_labirinto.global_position
	new_patriota.global_position = level.entrada_labirinto.global_position
	level.add_child(new_patriota)
	
func game_over():
	print("game_over")
	level.visible = false
	level.timer.stop()
	ui.label.text = "Game Over"
	ui.main_menu.visible = true
	ui.visible = true
