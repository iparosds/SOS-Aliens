# PauseMenu.gd
# Script responsável por controlar o menu de pausa do jogo, incluindo salvar, carregar, reiniciar e sair do jogo.

extends CanvasLayer

# Referências para os botões do menu de pausa
@onready var button_save: Button = $VBoxContainer/Button_Save
@onready var button_load: Button = $VBoxContainer/Button_Load
@onready var button_restart: Button = $VBoxContainer/Button_Restart
@onready var button_quit: Button = $VBoxContainer/Button_Quit
@onready var button_back_to_menu: Button = $VBoxContainer/Button_Back_To_Menu

# Indica se o jogo está atualmente pausado
var is_paused: bool = false


# Chamado quando o nó entra na árvore de cena pela primeira vez
func _ready() -> void:
	# Esconde o menu de pausa ao iniciar
	hide_pause_menu()
	
	# Conecta os sinais dos botões às suas respectivas funções
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_restart.pressed.connect(_on_restart_pressed)
	button_quit.pressed.connect(_on_quit_pressed)
	button_back_to_menu.pressed.connect(_on_back_to_menu_pressed)


# Captura entradas não tratadas, como pressionar a tecla de pausa
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		# Alterna entre mostrar e esconder o menu de pausa
		if not is_paused:
			show_pause_menu()
		else:
			hide_pause_menu()
		
		# Indica que a entrada já foi tratada, impedindo propagação
		get_viewport().set_input_as_handled()


# Exibe o menu de pausa e pausa o jogo
func show_pause_menu() -> void:
	get_tree().paused = true       
	visible = true                 
	is_paused = true               
	button_save.grab_focus()       


# Esconde o menu de pausa e retoma o jogo
func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false


# Salva o estado atual do jogo se estiver pausado
func _on_save_pressed() -> void:
	if not is_paused:
		return
	
	SaveManager.save_game()
	hide_pause_menu()


# Carrega o estado salvo do jogo se estiver pausado
func _on_load_pressed() -> void:
	if not is_paused:
		return
	
	SaveManager.load_game()
	hide_pause_menu()


# Reinicia a cena atual se estiver pausado
func _on_restart_pressed() -> void:
	if not is_paused:
		return
	
	hide_pause_menu()
	
	# Recarrega a cena atual de forma segura
	get_tree().reload_current_scene()


# Encerra o jogo se estiver pausado
func _on_quit_pressed() -> void:
	if not is_paused:
		return
	
	get_tree().quit()

# REtorna ao menu principal.
func _on_back_to_menu_pressed():
	if is_paused:
		get_tree().paused = false
		SceneManager.change_scene("res://scenes/MainMenu.tscn")
		hide_pause_menu()
