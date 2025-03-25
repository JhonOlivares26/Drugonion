extends Control

func _ready():
	$Button.connect("pressed", Callable(self, "_start_game"))

func _start_game():
	get_tree().change_scene_to_file("res://area_2d.tscn")  # Cambia a tu escena del juego
