extends Area2D
@onready var battle_music = $battle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
