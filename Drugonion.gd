extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 550
@export var max_health: int = 100  
@export var attack_damage_light: int = 10
@export var attack_damage_heavy: int = 20

var current_health: int
var can_attack: bool = true  

@onready var sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var hitbox = $Area2D  
@onready var hitbox_shape = $Area2D/HitboxHardAttack  

func _ready():
	add_to_group("fighters")
	current_health = max_health
	health_bar.value = current_health
	hitbox.monitoring = false  
	hitbox_shape.set_deferred("disabled", true)

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimiento horizontal
	var direction = Input.get_axis("move_left_player1", "move_right_player1")
	
	# Salto
	if is_on_floor() and Input.is_action_just_pressed("jump_player1"):
		velocity.y = jump_force
		sprite.play("jump")

	# Movimiento y animaciones
	if can_attack:
		velocity.x = direction * speed
	
		if is_on_floor():
			if direction == 0:
				sprite.play("idle")
			else:
				sprite.play("run")
				sprite.flip_h = direction < 0
		else:
			sprite.play("jump")

	move_and_slide()

	# Ataques
	if Input.is_action_just_pressed("light_attack_player1") and can_attack:
		attack("light")
	elif Input.is_action_just_pressed("hard_attack_player1") and can_attack:
		attack("hard")

func attack(type):
	can_attack = false
	hitbox.monitoring = true
	hitbox_shape.set_deferred("disabled", false)  

	if type == "light":
		sprite.play("light_attack")
		await get_tree().create_timer(0.2).timeout
	elif type == "hard":
		sprite.play("hard_attack")
		await get_tree().create_timer(0.4).timeout

	hitbox.monitoring = false
	hitbox_shape.set_deferred("disabled", true)  
	can_attack = true

func _on_Area2D_area_entered(area):
	if area.owner != self and area.owner.is_in_group("fighters"):
		var damage = attack_damage_light if sprite.animation == "light_attack" else attack_damage_heavy
		area.owner.take_damage(damage)

func take_damage(amount: int):
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die():
	queue_free()
