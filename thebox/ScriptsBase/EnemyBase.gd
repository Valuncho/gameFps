extends CharacterBody3D

class_name EnemyBase

@export var health: int = 100
@export var damage: int = 10
@export var speed: float = 3.0

func move_enemy(delta: float) -> void:
	# Método virtual: las clases concretas lo implementan
	pass

func receive_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	# Virtual también
	queue_free()
