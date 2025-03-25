extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 550
@export var max_health: int = 100
var health: int = max_health

@onready var sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar  # Referencia a la barra de vida

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("move_left_player2", "move_right_player2")
	velocity.x = direction * speed

	if Input.is_action_just_pressed("jump_player2") and is_on_floor():
		velocity.y = jump_force

	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
			sprite.flip_h = direction > 0
	else:
		sprite.play("jump")

	move_and_slide()

func take_damage(amount):
	health -= amount
	health = max(0, health)
	health_bar.value = health
	if health <= 0:
		die()

func die():
	queue_free()  # Elimina al personaje cuando su vida llega a 0
