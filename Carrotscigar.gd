extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 550

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimiento horizontal
	var direction = Input.get_axis("move_left_player2", "move_right_player2")
	velocity.x = direction * speed

	# Saltar
	if Input.is_action_just_pressed("jump_player2") and is_on_floor():
		velocity.y = jump_force

	# Animaciones
	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
			sprite.flip_h = direction > 0  # Voltear sprite si se mueve a la izquierda
	else:
		sprite.play("jump")

	move_and_slide()
