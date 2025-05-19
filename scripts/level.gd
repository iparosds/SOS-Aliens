extends Node2D
@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	print('game over')
	Controller.game_over()
