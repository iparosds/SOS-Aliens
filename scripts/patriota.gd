class_name Patriota extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimatedSprite2D = $AnimationPlayer
@onready var click_area: Area2D = $ClickArea
@onready var plock_sound: AudioStreamPlayer = $plock_sound
@export var speed: float = 100.0

var saida: Vector2 = Vector2(0,0)
var direction: Vector2


func _ready():
	navigation_agent_2d.target_position = saida
	click_area.input_event.connect(_on_click)


func _on_click(viewport:Node, event:InputEvent, shape_idx:int):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			plock_sound.play()
			kill()


func _physics_process(delta):
	if navigation_agent_2d.is_navigation_finished():
		queue_free()
		return
	
	animation_player.play("walk")
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	
	# Suaviza a velocidade com interpolação para um movimento mais natural
	velocity = velocity.lerp(direction * speed, delta)
	
	move_and_slide()


## Freeze e delay antes de explodir.
func kill():
	var _particle = preload("res://scenes/DeathParticlesBloodExplosion.tscn").instantiate()
	
	animation_player.stop()
	click_area.set_deferred("disabled", true)  # evita múltiplos cliques
	set_physics_process(false)
	
	await get_tree().create_timer(0.15).timeout
	
	_particle.global_position = global_position
	_particle.rotation = direction.angle()
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	
	Controller.add_point()
	queue_free()
