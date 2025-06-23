extends WeaponBase

@export var bullet_scene: PackedScene
@onready var bullet_spawn_point: Node3D = $Model/BulletSpawnPoint
var camera: Camera3D

func set_camera(cam: Camera3D):
	camera = cam

func shoot():
	if bullet_scene == null or bullet_spawn_point == null or camera == null:
		print("bullet_scene, bullet_spawn_point o camera es null")
		return
	var bullet = bullet_scene.instantiate()
	bullet.global_transform = bullet_spawn_point.global_transform
	if bullet.has_method("set_direction"):
		bullet.set_direction(camera.global_transform.basis.z)
	var bullets_container = get_tree().current_scene.get_node("BulletsContainer")
	if bullets_container:
		bullets_container.add_child(bullet)

# Maneja input para disparo simple (solo dispara cuando se presiona, no mantiene)
func handle_input():
	if Input.is_action_just_pressed("shoot"):
		shoot()
