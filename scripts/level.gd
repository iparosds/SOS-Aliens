class_name Level extends Node2D
@onready var timer: Timer = $Timer
@onready var spawn: Timer = $Spawn
@onready var entradas_labirinto: Node = $EntradasLabirinto
@onready var saidas_labirinto: Node = $SaidasLabirinto

@export var max_patriotas: int = 10

func _ready():
	print("level ready")
	Controller.level = self
	Controller.start_level()
	print(Controller.ui)

func _on_timer_timeout() -> void:
	print('game over')
	Controller.game_over()

func _on_spawn_timeout() -> void:
	Controller.spawn_patriota()
