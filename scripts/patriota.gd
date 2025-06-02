class_name Patriota extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimatedSprite2D = $AnimationPlayer
@onready var click_area: Area2D = $ClickArea
@onready var kill_timer: Timer = $KillTimer

# Velocidade de movimentação da barata (pode ser configurada no editor)
@export var speed: float = 100.0

var saida: Vector2 = Vector2(0,0)

# Direção atual do movimento da barata (atualizada a cada frame)
var direction: Vector2

signal clicked

func _ready():
	navigation_agent_2d.target_position = saida
	click_area.input_event.connect(_on_click)
	kill_timer.timeout.connect(queue_free)
	
func _on_click(viewport:Node, event:InputEvent, shape_idx:int):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		emit_signal("clicked")
		kill_timer.start()
	
func _physics_process(delta):
	# Se o agente já chegou ao destino, remove a barata da cena
	if navigation_agent_2d.is_navigation_finished():
		queue_free()
		return
	
	animation_player.play("walk")
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	
	# Suaviza a velocidade com interpolação para um movimento mais natural
	velocity = velocity.lerp(direction * speed, delta)
	
	# Move a barata de acordo com a física do Godot
	move_and_slide()
