extends EnemyBase

@onready var player: Node3D = get_tree().get_first_node_in_group("PlayerCharacter")
@onready var hitbox: Area3D = $HitboxArea

func _ready():
	hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerCharacter"):
		if body.has_method("take_damage"):
			body.take_damage(10)
		else:
			print("Jugador no tiene método take_damage")

func _on_Hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_attack"):
		receive_damage(20)

func take_damage(amount: int) -> void:
	receive_damage(amount)

func receive_damage(amount: int) -> void:
	health -= amount
	print("Vida restante:", health)
	if health <= 0:
		die()
