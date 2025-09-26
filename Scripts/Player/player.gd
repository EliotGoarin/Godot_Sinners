extends CombatEntity
class_name Player

const SPEED = 300.0
var current_speed := SPEED

const JUMP_VELOCITY = -300.0
const DODGE_SPEED = 800

var is_dodging = false
var can_dash = true
var dash_duration = 0.2
var dash_direction = 0

const BASE_DAMAGE = 2
var is_attacking := false
var can_damage := false
var already_hit_bodies := []

var is_invincible = false
var max_jumps = 2
var jumps_left = 2

signal attack_finished

@onready var attack_area: Area2D = $Attack_area
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var fire_point: Marker2D = $FirePoint

@export var damage = BASE_DAMAGE
@export var fireball_scene: PackedScene
@export var inv: Inv

func _ready():
	super()
	attack_area.damage = damage
	attack_area.add_to_group("player_attack")
	connect("died", self._on_player_death)
	connect("health_changed", self._on_player_health_changed)
	attack_area.monitoring = false
	attack_area.connect("area_entered", Callable(self, "_on_attack_area_entered"))


func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor() and not is_dodging:
		velocity += get_gravity() * delta

	if is_on_floor():
		jumps_left = max_jumps

	# Attaque simple
	if Input.is_action_just_pressed("Hit") and not is_attacking:
		start_attack()

	# Saut
	if Input.is_action_just_pressed("Jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# Déplacement horizontal
	var direction := Input.get_axis("Left", "Right")

	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	# Fireball
	if Input.is_action_just_pressed("Projectile"):
		if inv.has_item("fireball"):
			shoot_fireball()

	# Dodge (dash)
	if Input.is_action_just_pressed("Dodge") and direction and can_dash:
		animated_sprite_2d.play("Dodge")
		is_dodging = true
		can_dash = false
		dash_direction = direction
		velocity = Vector2(dash_direction * DODGE_SPEED, 0)
		$Dodge_timer.start(dash_duration)
		$Can_dodge_timer.start()
		return

	# Fin du dash
	if is_dodging:
		velocity.x = dash_direction * DODGE_SPEED
		velocity.y = 0
	else:
		if direction:
			velocity.x = direction * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)

	# Animations normales
	if not is_attacking and not is_dodging:
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("Idle")
			else:
				animated_sprite_2d.play("Run")
		else:
			if velocity.y < 0:
				animated_sprite_2d.play("Jump")
			else:
				animated_sprite_2d.play("Falling")

	move_and_slide()

func _on_dodge_timer_timeout() -> void:
	is_dodging = false

func _on_can_dodge_timer_timeout() -> void:
	can_dash = true

func shoot_fireball():
	if fireball_scene:
		var fireball = fireball_scene.instantiate()
		get_parent().add_child(fireball)
		fireball.global_position = fire_point.global_position

		fireball.direction = Vector2.LEFT if animated_sprite_2d.flip_h else Vector2.RIGHT


func start_attack():
	is_attacking = true
	animated_sprite_2d.play("Attack1")

	# Active la hitbox (Area2D)
	attack_area.monitoring = true

	await get_tree().create_timer(0.2).timeout  # durée d’activation
	attack_area.monitoring = false
	is_attacking = false


func enable_attack_hitbox(start_delay: float, duration: float) -> void:
	await get_tree().create_timer(start_delay).timeout
	can_damage = true
	attack_area.monitoring = true
	await get_tree().create_timer(duration).timeout
	attack_area.monitoring = false
	can_damage = false

func reset_attack():
	is_attacking = false
	current_speed = SPEED
	already_hit_bodies.clear()
	emit_signal("attack_finished")

########## Collecting items #############
func collect(item):
	inv.insert(item)

########## Animation signal #############
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Attack1":
		reset_attack()

func _on_player_death():
	print("Tu es mort...")

func _on_player_health_changed(value):
	print("PV du joueur :", value)

func _on_attack_area_entered(area: Area2D):
	var target = area.get_parent()
	if target is Boss:  # ou `CombatEntity` si tu généralises
		target.take_damage(damage)
