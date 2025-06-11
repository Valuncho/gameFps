extends EnemyBase

@onready var player: Node3D = get_tree().get_first_node_in_group("PlayerCharacter")


func _physics_process(delta: float) -> void:
	if player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

func _on_Hitbox_area_entered(area):
	if area.is_in_group("player_attack"):
		receive_damage(20)

func take_damage(amount: int) -> void:
	receive_damage(amount)

func receive_damage(amount: int) -> void:
	health -= amount
	print("Vida restante:", health)
	if health <= 0:
		die()
