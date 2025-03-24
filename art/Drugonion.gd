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
	var direction = Input.get_axis("move_left_player1", "move_right_player1")
<<<<<<< HEAD
	velocity.x = direction * speed
=======

	# Evitar movimiento mientras ataca
	if not attacking:
		velocity.x = direction * speed
>>>>>>> d92c69a (Anim,aciones de golpes realizadas)

	# Saltar
	if Input.is_action_just_pressed("jump_player1") and is_on_floor():
		velocity.y = jump_force

<<<<<<< HEAD
	# Animaciones
	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
			sprite.flip_h = direction < 0  # Voltear sprite si se mueve a la izquierda
	else:
		sprite.play("jump")

	move_and_slide()
=======
	# Ejecutar ataque si se presiona "J"
	if Input.is_action_just_pressed("soft_attack_player1") and not attacking:
		atacar()
		
	if Input.is_action_just_pressed("hard_attack_player1") and not attacking:
		atacar_fuerte()

	move_and_slide()

func atacar():
	attacking = true
	sprite.animation = "soft_attack"  # Cambia a la animación de ataque
	await get_tree().create_timer(0.5).timeout  # Espera 0.5 segundos
	sprite.animation = original_animation  # Regresa a la animación original
	attacking = false
	
func atacar_fuerte():
	attacking = true
	sprite.animation = "hard_attack"  # Cambia a la animación de ataque
	await get_tree().create_timer(0.5).timeout  # Espera 0.5 segundos
	sprite.animation = original_animation  # Regresa a la animación original
	attacking = false
>>>>>>> d92c69a (Anim,aciones de golpes realizadas)
