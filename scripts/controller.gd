extends Node

var scene_manager: SceneManager
var current_level

func change_level(level):
	scene_manager.level.visible = true
	var new_level = load(level).instantiate()
	scene_manager.level.add_child(new_level)
	scene_manager.level.timer.start()
	scene_manager.ui.main_menu.visible = false
	scene_manager.ui.label.text = "Bom jogo!"
	current_level = new_level

func game_over():
	scene_manager.level.visible = false
	scene_manager.level.timer.stop()
	scene_manager.ui.label.text = "Game Over"
	scene_manager.ui.main_menu.visible = true
	scene_manager.ui.visible = true
