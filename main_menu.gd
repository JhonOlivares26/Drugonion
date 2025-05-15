
extends Control
@onready var menu_sound = $MenuMusic # Referencia al nuevo AudioStreamPlayer
func _ready():
	$Button.connect("pressed", Callable(self, "_start_game"))
	menu_sound.play() # Reproducimos el sonido para el menu

func _start_game():
	get_tree().change_scene_to_file("res://area_2d.tscn")  # Cambia a tu escena del juego
