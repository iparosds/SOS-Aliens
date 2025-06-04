class_name Patriota extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimatedSprite2D = $AnimationPlayer
@onready var click_area: Area2D = $ClickArea

@export var deathParticle: PackedScene

# Velocidade de movimentação da barata (pode ser configurada no editor)
@export var speed: float = 100.0

var saida: Vector2 = Vector2(0,0)

# Direção atual do movimento da barata (atualizada a cada frame)
var direction: Vector2

signal clicked

func _ready():
	navigation_agent_2d.target_position = saida
	click_area.input_event.connect(_on_click)
	
func _on_click(viewport:Node, event:InputEvent, shape_idx:int):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		emit_signal("clicked")
		kill()
	
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

## Freeze e delay antes de explodir.
func kill():
	var _particle = deathParticle.instantiate()
	animation_player.stop()
	click_area.set_deferred("disabled", true)  # evita múltiplos cliques
	set_physics_process(false)

	await get_tree().create_timer(0.15).timeout

	_particle.global_position = global_position
	_particle.rotation = direction.angle()
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)

	queue_free()


#func kill():
	#var _particle = deathParticle.instantiate()
	#_particle.global_position = global_position
	#_particle.rotation = direction.angle()
	#_particle.emitting = true
	#get_tree().current_scene.add_child(_particle)
#
	#queue_free()
#
	#await get_tree().create_timer(0.4).timeout
	#_particle.queue_free()
