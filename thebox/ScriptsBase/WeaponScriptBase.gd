extends Node3D
class_name WeaponBase

var current_ammo: int
var is_reloading: bool = false

func init_ammo(mag_size: int) -> void:
	current_ammo = mag_size

func reload(reload_time: float, mag_size: int) -> void:
	if is_reloading:
		return
	is_reloading = true
	print("Recargando...")
	await get_tree().create_timer(reload_time).timeout
	current_ammo = mag_size
	is_reloading = false
	print("Recarga completa")

func can_shoot() -> bool:
	return not is_reloading and current_ammo > 0

func shoot():
	print("")

func equip():
	pass

func unequip():
	pass

# Este método se llama cada frame desde el jugador y permite que cada arma
# maneje su propio comportamiento de disparo (por ejemplo, disparo automático o único).
# Las armas que lo necesiten pueden sobrescribirlo. Por defecto no hace nada.
func handle_input():
	pass
