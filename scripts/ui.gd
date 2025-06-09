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


## Main menu
func _on_choose_level_button_pressed() -> void:
	main_menu.visible = false
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


var levels: Dictionary = {
	1 : {
		"label": "Level 1",
		"url": "level_01.tscn",
		"unblock": "_level01"
	},
	2 : {
		"label": "Level 2",
		"url": "level_02.tscn",
		"unblock": "_level01"
	},
	3 : {
		"label": "Level 3",
		"url": "level_03.tscn",
		"unblock": "_level01"
	}
}

func _level01() -> bool:
	return true

## Gera dinamicamente os botões de seleção de fases a partir dos arquivos encontrados na pasta levels
func _generate_level_buttons():
	# Abre o diretório onde os arquivos de fase estão localizados
	var dir = DirAccess.open("res://levels")
	if dir == null:
		print("Erro ao abrir diretório levels.")
		return
	
	var level_files := []

	# Inicia a leitura dos arquivos no diretório
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		# Adiciona à lista apenas os arquivos de cena .tscn que não sejam diretórios
		if file_name.ends_with(".tscn") and not dir.current_is_dir():
			level_files.append(file_name)
		file_name = dir.get_next()

	# Ordena os arquivos com base no número contido no nome
	level_files.sort_custom(func(a, b):
		var a_number = _extract_level_number(a)
		var b_number = _extract_level_number(b)
		return a_number < b_number
	)

	# Acessa o VBoxContainer dentro da hierarquia de menus, onde os botões serão adicionados
	var vbox = level_menu.get_node("ScrollContainer/MarginContainer/VBoxContainer")
	
	# Cria um botão para cada arquivo de level
	for file in level_files:
		var level_path = "res://levels/" + file
		var button = Button.new()
		
		# Define o texto do botão baseado no nome do arquivo
		button.text = " " + file.get_basename().capitalize() + " "
		
		# Define que o botão deve expandir horizontalmente para preencher o espaço
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Conecta o botão para que carregue e inicie o nível correspondente
		button.pressed.connect(func():
			level_menu.visible = false
			Controller.change_level(level_path)
			Controller.start_level()
		)
		
		# Adiciona o botão ao VBoxContainer
		vbox.add_child(button)


## Extrai o número do nível a partir do nome do arquivo
func _extract_level_number(file_name: String) -> int:
	var regex = RegEx.new()
	# Expressão regular para encontrar o primeiro número na string
	regex.compile(r"\d+")
	
	var result = regex.search(file_name)
	if result:
		# Converte o número encontrado para inteiro
		return int(result.get_string())
	
	# Retorna 0 caso nenhum número seja encontrado
	return 0
