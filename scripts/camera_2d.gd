extends Camera2D
@export var CameraPanSpeed:int = 10

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
	if Input.is_action_just_pressed("zoom_in"):
		zoom.x += 0.1
		zoom.y += 0.1
	if Input.is_action_just_pressed("zoom_out"):
		zoom.x -= 0.1
		zoom.y -= 0.1
