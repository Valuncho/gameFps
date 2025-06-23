extends Node3D

@export var speed: float = 40.0
@export var damage: int = 50

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: RayCast3D = $RayCast3D
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var destroy_timer: Timer = $Timer

var impacted: bool = false

func _ready():
	destroy_timer.start()


func _process(delta: float) -> void:
	if impacted:
		return

	position += transform.basis.z * speed * delta

	if ray.is_colliding():
		impacted = true
		mesh.visible = false
		particles.emitting = true
		ray.enabled = false
		var collider = ray.get_collider()
		if collider != null and collider.has_method("take_damage"):
			collider.take_damage(damage)

		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
