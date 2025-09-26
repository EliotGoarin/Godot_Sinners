extends CharacterBody2D
class_name Boss

@export var max_health := 50
@export var damage := 3
const SPEED = 150

var current_health := max_health
var is_attacking := false
var can_damage := false
var already_hit := []
var player_in_attack_zone := false

enum State { IDLE, ATTACK, CHASE }
var state = State.IDLE
var player_target: Node2D = null

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var boss_hurtbox: Area2D = $BossHurtbox
@onready var boss_attack_area: Area2D = $BossAttackArea
@onready var boss_awareness_area: Area2D = $BossAwarenessArea
@onready var healthbar: ProgressBar = $Healthbar


func _ready():
	boss_attack_area.body_entered.connect(_on_boss_attack_area_body_entered)
	boss_attack_area.body_exited.connect(_on_boss_attack_area_body_exited)
	boss_attack_area.connect("area_entered", Callable(self, "_on_boss_attack_hit"))
	boss_awareness_area.connect("body_entered", Callable(self, "_on_boss_awareness_entered"))
	boss_hurtbox.connect("area_entered", Callable(self, "_on_boss_hurtbox_entered"))
	boss_attack_area.monitoring = true

	# (et assure le bon signal: le Player est un Body, pas une Area)
	if not boss_attack_area.body_entered.is_connected(_on_boss_attack_area_body_entered):
		boss_attack_area.body_entered.connect(_on_boss_attack_area_body_entered)

	if not boss_attack_area.body_exited.is_connected(_on_boss_attack_area_body_exited):
		boss_attack_area.body_exited.connect(_on_boss_attack_area_body_exited)

	update_healthbar()
	# Important: l'Area doit surveiller les bodies pour que body_entered se déclenche
	$BossAttackArea.monitoring = true

func _physics_process(delta):
	if current_health <= 0:
		return

	match state:
		State.IDLE:
			pass

		State.CHASE:
			if player_target:
				var direction = (player_target.global_position - global_position).normalized()
				velocity = direction * SPEED

		State.ATTACK:
			if not is_attacking:
				start_attack()

	if player_target:
		animated_sprite_2d.flip_h = player_target.global_position.x < global_position.x

	move_and_slide()

# Quand le joueur entre dans la zone de détection du boss
func _on_boss_awareness_entered(body: Node):
	if body is Player:
		player_target = body
		state = State.CHASE

# Quand le joueur entre dans la hitbox du boss pendant son attaque
func _on_boss_attack_hit(area: Area2D):
	if not can_damage:
		return
	var target = area.get_parent()
	if target is Player and target not in already_hit:
		state = State.ATTACK
		target.take_damage(damage)
		already_hit.append(target)

# Quand le boss reçoit une attaque du joueur
func _on_boss_hurtbox_entered(area: Area2D):
	if area.is_in_group("player_attack") and area.get_meta("active", false):
		take_damage(area.damage)



func take_damage(amount):
	current_health = max(current_health - amount, 0)
	update_healthbar()
	if current_health == 0:
		die()

func update_healthbar():
	healthbar.value = current_health

func die():
	animated_sprite_2d.play("Death")
	await animated_sprite_2d.animation_finished
	queue_free()

func reset_attack():
	can_damage = false
	is_attacking = false
	already_hit.clear()


func Attack1_start_hit():
	# Appelée par un Call Method Track dans l'animation Attack1 au moment de l'impact
	can_damage = true

func Attack1_end_hit():
	# Appelée par un Call Method Track dans l'animation Attack1 à la fin de la fenêtre de dégâts
	can_damage = false

func _on_boss_attack_area_body_entered(body):
	if body is Player:
		player_in_attack_zone = true
		if not is_attacking:
			start_attack()
	if can_damage and body is CombatEntity and body not in already_hit:
		body.take_damage(damage)
		already_hit.append(body)




func start_attack():
	if is_attacking:
		return
	is_attacking = true
	animated_sprite_2d.play("Attack1")
	await get_tree().create_timer(0.2).timeout
	can_damage = true
	boss_attack_area.monitoring = true
	await get_tree().create_timer(0.2).timeout
	can_damage = false
	boss_attack_area.monitoring = false
	already_hit.clear()
	is_attacking = false
	state = State.CHASE
	
	
func _return_to_idle():
	can_damage = false
	already_hit.clear()
	velocity = Vector2.ZERO
	state = State.IDLE
	if animated_sprite_2d.animation != "Idle":
		print("should be idle")
		animated_sprite_2d.play("Idle")

func _on_boss_attack_area_body_exited(body):
	if not (body is Player):
		return

	# Le seul joueur vient de sortir : on libère l'état et on repasse en Idle
	player_in_attack_zone = false
	can_damage = false
	is_attacking = false
	already_hit.clear()

	state = State.IDLE
	if animated_sprite_2d.animation != "Idle":
		animated_sprite_2d.play("Idle")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Attack1":
		reset_attack()
