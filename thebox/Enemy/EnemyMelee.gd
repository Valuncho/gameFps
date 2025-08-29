extends EnemyBase

@onready var player: Node3D = get_tree().get_first_node_in_group("PlayerCharacter")
@onready var hitbox: Area3D = $HitboxArea

# Modelo animado
@export var enemy_model_scene: PackedScene
var enemy_model_instance: Node3D
var anim_player: AnimationPlayer

func _ready():
	hitbox.body_entered.connect(_on_body_entered)

	# Instanciar modelo
	if enemy_model_scene:
		enemy_model_instance = enemy_model_scene.instantiate()
		add_child(enemy_model_instance)
		enemy_model_instance.transform.origin = Vector3.ZERO

		# Obtener AnimationPlayer
		if enemy_model_instance.has_node("AnimationPlayer"):
			anim_player = enemy_model_instance.get_node("AnimationPlayer")
			anim_player.play("Animation")
 

func _physics_process(delta):
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()

	# Animacion segun movimiento
	if anim_player:
		if velocity.length() > 0.1:
			if anim_player.current_animation != "Running":
				anim_player.play("Running")
		else:
			if anim_player.current_animation != "Idle":
				anim_player.play("Idle")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerCharacter"):
		if body.has_method("take_damage"):
			body.take_damage(10)

			# Empuje
			var push_direction = (body.global_transform.origin - global_transform.origin).normalized()
			var push_force = 100 #modificar la fuerza
			body.velocity += push_direction * push_force

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
