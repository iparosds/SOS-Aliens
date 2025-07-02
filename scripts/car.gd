class_name Car
extends CharacterBody2D

@onready var click_area: Area2D = $ClickArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D

var dragging: bool = false
var drag_enabled: bool = true
var drag_time: float = 3.0
var wait_time: float = 15.0


func _ready():
	click_area.input_event.connect(_on_click_area_input_event)


func _process(_delta):
	if dragging:
		var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
		
		global_position = mouse_pos
		sprite_2d.scale = Vector2(1.15, 1.15)
		shape.disabled = true


func _on_click_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if drag_enabled:
					start_drag()
			else:
				if dragging:
					stop_drag()


func start_drag():
	dragging = true
	Controller.car_dragging = true
	drag_enabled = true
	await drag_duration()


func stop_drag():
	dragging = false
	Controller.car_dragging = false
	sprite_2d.scale = Vector2(1, 1)
	shape.disabled = false
	drag_enabled = false
	await wait_duration()


func drag_duration():
	var total = drag_time
	for i in range(total as int, 0, -1):
		if Controller.ui:
			Controller.ui.set_drag_timer_text("Drag: %ds" % i, Color.LIGHT_GREEN)
		await get_tree().create_timer(1.0).timeout
	
	if dragging:
		stop_drag()


func wait_duration():
	var total = wait_time
	for i in range(total as int, 0, -1):
		if Controller.ui:
			Controller.ui.set_drag_timer_text("Espera: %ds" % i, Color.SALMON)
		await get_tree().create_timer(1.0).timeout
	
	drag_enabled = true
	if Controller.ui:
		Controller.ui.set_drag_timer_text("Drag!", Color.GREEN)
