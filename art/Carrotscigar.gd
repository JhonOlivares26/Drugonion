extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 550

@onready var sprite = $AnimatedSprite2D
<<<<<<< HEAD
=======
@onready var original_animation = sprite.animation  # Guarda la animación original

var attacking = false
>>>>>>> d92c69a (Anim,aciones de golpes realizadas)

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimiento horizontal
	var direction = Input.get_axis("move_left_player2", "move_right_player2")
<<<<<<< HEAD
	velocity.x = direction * speed
=======

	# Evitar movimiento mientras ataca
	if not attacking:
		velocity.x = direction * speed
>>>>>>> d92c69a (Anim,aciones de golpes realizadas)

	# Saltar
	if Input.is_action_just_pressed("jump_player2") and is_on_floor():
		velocity.y = jump_force

<<<<<<< HEAD
	# Animaciones
	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
			sprite.flip_h = direction > 0  # Voltear sprite si se mueve a la derecha
	else:
		sprite.play("jump")

	move_and_slide()
=======
	# Ejecutar ataque si se presiona la tecla correspondiente
	if Input.is_action_just_pressed("soft_attack_player2") and not attacking:
		atacar()
	
	if Input.is_action_just_pressed("hard_attack_player2") and not attacking:
		atacar_fuerte()

	# Animaciones (solo si no está atacando)
	if not attacking:
		if is_on_floor():
			if direction == 0:
				sprite.play("idle")
			else:
				sprite.play("run")
				sprite.flip_h = direction > 0  # Voltear sprite si se mueve a la derecha
		else:
			sprite.play("jump")

	move_and_slide()

func atacar():
	attacking = true
	sprite.play("soft_attack")  # Se usa la animación correcta según la imagen
	await get_tree().create_timer(0.5).timeout  # Espera 0.5 segundos
	sprite.play(original_animation)  # Regresa a la animación original
	attacking = false
	
func atacar_fuerte():
	attacking = true
	sprite.play("hard_attack")  # Se usa la animación correcta según la imagen
	await get_tree().create_timer(0.5).timeout  # Espera 0.5 segundos
	sprite.play(original_animation)  # Regresa a la animación original
	attacking = false
>>>>>>> d92c69a (Anim,aciones de golpes realizadas)
