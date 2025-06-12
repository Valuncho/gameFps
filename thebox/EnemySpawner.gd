extends Node3D

@onready var enemy_scene = preload("res://Enemy/EnemyMelee.tscn")
@onready var spawn_timer: Timer = $Timer

func _ready():
	spawn_timer.start()


func _on_timer_timeout() -> void:
	var newEnemy = enemy_scene.instantiate()
	get_parent().add_child(newEnemy)
	
	newEnemy.global_position = global_position
