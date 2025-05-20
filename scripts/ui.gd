class_name UI extends Node2D
@onready var main_menu: CanvasLayer = $main_menu
@onready var header: CanvasLayer = $header
@onready var label: Label = $header/Label
@onready var level_1_button: Button = $main_menu/MarginContainer/ButtonVBoxContainer/level_1


func _ready():
	Controller.ui = self
	level_1_button.grab_focus()
	

func _on_level_1_pressed() -> void:
	Controller.change_level("res://levels/level_01.tscn")

func _on_level_2_pressed() -> void:
	Controller.change_level("res://levels/level_02.tscn")
 
