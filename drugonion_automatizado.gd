extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_force: float = -400.0
@export var gravity: float = 550
@export var max_health: int = 100  
@export var attack_damage_light: int = 10
@export var attack_damage_heavy: int = 20
@export var patrol_distance: float = 300.0  # Distancia máxima antes de girar

var current_health: int
var can_attack: bool = true  
var direction: int = 1  # 1 = derecha, -1 = izquierda
var start_position: Vector2

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
	hitbox.monitorable = true
	start_position = global_position  # Guardamos la posición inicial

func _physics_process(delta):
	# Aplicar gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta

	# Patrullar automáticamente (cambiar de dirección si llega al límite)
	if abs(global_position.x - start_position.x) > patrol_distance:
		direction *= -1  # Cambiar dirección
		sprite.flip_h = direction < 0  

	# Movimiento automático
	velocity.x = direction * speed

	# Pequeña probabilidad de saltar (para hacerlo más dinámico)
	if is_on_floor() and randi_range(0, 100) < 3:
		velocity.y = jump_force
		sprite.play("jump")

	# Elegir animación
	if is_on_floor():
		if velocity.x == 0:
			sprite.play("idle")
		else:
			sprite.play("walk")

	move_and_slide()

func attack(type):
	can_attack = false
	hitbox.monitoring = true
	hitbox_shape.set_deferred("disabled", false)  
	print("✅ Hitbox activada")

	if type == "light":
		sprite.play("light_attack")
		await get_tree().create_timer(0.2).timeout
	elif type == "hard":
		sprite.play("hard_attack")
		await get_tree().create_timer(0.4).timeout

	hitbox.monitoring = false
	hitbox_shape.set_deferred("disabled", true)  
	print("❌ Hitbox desactivada")
	can_attack = true

func _on_Area2D_area_entered(area):
	if area and area.owner != self and area.owner.is_in_group("fighters"):
		print("⚡ Hitbox detectó algo:", area.owner.name)
		if can_attack:
			var attack_type = "light" if randi() % 2 == 0 else "hard"
			attack(attack_type)
			var damage = attack_damage_light if attack_type == "light" else attack_damage_heavy
			print("🔥 Golpeando a", area.owner.name, "con", damage, "de daño")
			area.owner.take_damage(damage)

func take_damage(amount: int):
	current_health -= amount
	health_bar.value = current_health
	print("💥 Me atacaron, vida restante:", current_health)
	if current_health <= 0:
		die()

func die():
	print("💀", name, "ha muerto")
	queue_free()
