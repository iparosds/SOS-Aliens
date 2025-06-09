class_name UI extends Node2D

@onready var main_menu: CanvasLayer = $main_menu
@onready var header: CanvasLayer = $header
@onready var label: Label = $header/Label
@onready var level_menu: CanvasLayer = $level_menu
@onready var pause_menu: CanvasLayer = $pause_menu
@onready var game_over_menu: CanvasLayer = $game_over_menu
@onready var intro_container: CanvasLayer = $intro_container
@onready var intro_1: VideoStreamPlayer = $intro_container/intro1
@onready var intro_2: VideoStreamPlayer = $intro_container/intro2
@onready var score_label: Label = $header/ScoreLabel

var is_paused: bool = false


func _ready():
	Controller.ui = self
	
	main_menu.visible = false
	game_over_menu.visible = false
	
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	hide_pause_menu()
	
	intro_1.visible = true
	intro_2.visible = false
	intro_container.visible = true
	
	intro_1.play()
	intro_1.connect("finished", Callable(self, "_on_intro_1_finished"))
	
	_generate_level_buttons()
	Controller.load_high_scores()


## Intro
func _on_intro_1_finished():
	intro_1.visible = false
	intro_2.visible = true
	intro_2.play()
	intro_2.connect("finished", Callable(self, "_on_intro_2_finished"))


func _on_intro_2_finished():
	intro_container.visible = false
	main_menu.visible = true


func _on_skip_intro_button_pressed() -> void:
	intro_1.stop()
	intro_2.stop()
	intro_container.visible = false
	main_menu.visible = true


## Score
func update_score():
	score_label.text = "Pontuação: %d" % Controller.current_score


## Main menu
func _on_choose_level_button_pressed() -> void:
	main_menu.visible = false
	
	var buttons_container = level_menu.get_node("ScrollContainer/MarginContainer/VBoxContainer")
	
	for child in buttons_container.get_children():
		child.queue_free()
	
	_generate_level_buttons()
	
	level_menu.visible = true


func _on_button_quit_from_main_menu_pressed() -> void:
	get_tree().quit()


## Pause menu
func show_pause_menu() -> void:
	get_tree().paused = true
	pause_menu.visible = true
	is_paused = true


func hide_pause_menu() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	is_paused = false


func _on_button_continue_pressed() -> void:
	if not is_paused:
		return
	
	hide_pause_menu()


func _on_button_restart_pressed() -> void:
	if not is_paused:
		return
	
	hide_pause_menu()
	Controller.restart_level()


func _on_button_quit_pressed() -> void:
	if not is_paused:
		return
	
	get_tree().quit()


func _on_button_back_to_menu_pressed() -> void:
	if not is_paused:
		return
	
	Controller.back_to_main_menu()


## Game over menu
func _on_button_retry_pressed() -> void:
	game_over_menu.visible = false
	get_tree().paused = false
	Controller.restart_level()


func _on_button_back_to_main_menu_pressed() -> void:
	game_over_menu.visible = false
	get_tree().paused = false
	Controller.back_to_main_menu()


func _on_button_quit_from_game_over_pressed() -> void:
	get_tree().quit()


## Level menu
var levels: Dictionary = {
	1 : {
		"label": "Rio de Janeiro",
		"url": "level_01.tscn",
		"unblock": "_level01"
	},
	2 : {
		"label": "Campinas",
		"url": "level_02.tscn",
		"unblock": "_level02"
	},
	3 : {
		"label": "Fortaleza",
		"url": "level_03.tscn",
		"unblock": "_level03"
	}
}


func _level01() -> bool:
	return true


func _level02() -> bool:
	return true


func _level03() -> bool:
	return false


func _generate_level_buttons():
	var buttons_container = level_menu.get_node("ScrollContainer/MarginContainer/VBoxContainer")
	
	var level_keys = levels.keys()
	level_keys.sort()
	
	for level in level_keys:
		var level_data = levels[level]
	
		var label = level_data["label"]
		var level_path = "res://levels/" + level_data["url"]
		var unlock_level = level_data["unblock"]
		
		var button = Button.new()
		var high_score = Controller.high_scores.get(level_data["url"].get_basename(), 0)
		button.text = " %s - Score: %d" % [label, high_score]

		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Verifica se o nível está desbloqueado chamando a função armazenada em unblock.
		var is_unlocked = false
		if has_method(unlock_level):
			is_unlocked = call(unlock_level)
		
		button.disabled = not is_unlocked

		# Conecta a ação ao botão se ele estiver desbloqueado.
		if is_unlocked:
			button.pressed.connect(func():
				level_menu.visible = false
				Controller.change_level(level_path)
				Controller.start_level()
			)
		
		buttons_container.add_child(button)


func _on_back_to_main_menu_pressed() -> void:
	level_menu.visible = false
	get_tree().paused = false
	Controller.back_to_main_menu()
