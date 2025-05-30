class_name UI extends Node2D

@onready var main_menu: CanvasLayer = $main_menu
@onready var header: CanvasLayer = $header
@onready var label: Label = $header/Label
@onready var level_menu: CanvasLayer = $level_menu
@onready var pause_menu: CanvasLayer = $pause_menu
@onready var game_over_menu: CanvasLayer = $game_over_menu

var is_paused: bool = false

func _ready():
	Controller.ui = self
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	hide_pause_menu()
	game_over_menu.visible = false


## Main menu
func _on_level_1_pressed() -> void:
	Controller.change_level("res://levels/level_01.tscn")

func _on_level_2_pressed() -> void:
	Controller.change_level("res://levels/level_02.tscn")
 
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
