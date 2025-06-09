extends Camera2D

var CameraPanSpeed:int = 10
var dragging := false
var last_mouse_position := Vector2.ZERO

func _ready():
	Controller.camera_2d = self


func reset_camera():
	position.x = 223
	position.y = 414
	zoom.x = 1
	zoom.y = 1


func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		position.y -= CameraPanSpeed
	if Input.is_action_pressed("down"):
		position.y += CameraPanSpeed
	if Input.is_action_pressed("left"):
		position.x -= CameraPanSpeed
	if Input.is_action_pressed("right"):
		position.x += CameraPanSpeed
	if Input.is_action_just_pressed("zoom_in") and zoom.x < 1.5:
		zoom.x += 0.1
		zoom.y += 0.1
	if Input.is_action_just_pressed("zoom_out") and zoom.x > 0.5:
		zoom.x -= 0.1
		zoom.y -= 0.1


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				dragging = true
				last_mouse_position = get_viewport().get_mouse_position()
			else:
				dragging = false
	
	if event is InputEventMouseMotion and dragging:
		var current_mouse_position = get_viewport().get_mouse_position()
		var delta = last_mouse_position - current_mouse_position
		position += delta * zoom
		last_mouse_position = current_mouse_position
