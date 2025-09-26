# CombatEntity.gd
extends CharacterBody2D
class_name CombatEntity

@export var max_health: int = 10
@export var current_health: int = max_health

signal died
signal health_changed(new_value: int)

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)
	emit_signal("health_changed", current_health)
	if current_health == 0:
		die()

func heal(amount: int):
	current_health += amount
	current_health = min(current_health, max_health)
	emit_signal("health_changed", current_health)

func die():
	emit_signal("died")
	  # à override si tu veux une animation spéciale
