extends CanvasLayer

@onready var achievement_title_label: Label = $Panel/VBoxContainer/AchievementTitleLabel


func _ready():
	visible = false


func show_achievement(level_name: String):
	print("Exibindo popup de conquista:", level_name)
	achievement_title_label.text = "Novo nível desbloqueado:\n" + level_name
	visible = true
	get_tree().paused = true


func _on_achievement_ok_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	queue_free()
