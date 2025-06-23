extends Node3D
class_name WeaponBase

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
