class_name SceneManager extends Node2D

@onready var sound_track: AudioStreamPlayer = $SoundPlayer/SoundTrack
@onready var ray_shot: AudioStreamPlayer = $SoundPlayer/RayShot

func _ready():
	Controller.scene_manager = self
	
	sound_track.process_mode = Node.PROCESS_MODE_ALWAYS
	sound_track.play()
