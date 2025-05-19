class_name SceneManager extends Node2D
@onready var level: Node2D = $Level
@onready var ui: Node2D = $UI

func _ready():
	Controller.scene_manager = self
