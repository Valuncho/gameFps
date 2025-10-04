extends CanvasLayer

class_name HUD

#label references variables
@onready var currentStateLT = $PlayCharInfos/VBoxContainer2/CurrentStateLabelText
@onready var desiredMoveSpeedLT = $PlayCharInfos/VBoxContainer2/DesiredMoveSpeedLabelText
@onready var velocityLT = $PlayCharInfos/VBoxContainer2/VelocityLabelText
@onready var nbJumpsInAirAllowedLT = $PlayCharInfos/VBoxContainer2/NbJumpsInAirAllowedLabelText
@onready var framesPerSecondLT = $PlayCharInfos2/VBoxContainer2/FramesPerSecondLabelText
@onready var healthBar: ProgressBar = $HealthBar
@onready var ammoLabel: Label = $AmmoLabel
var current_weapon = null

func _process(_delta):
	displayCurrentFPS()

func displayCurrentState(currentState : String):
	currentStateLT.set_text(str(currentState))

func displayDesiredMoveSpeed(desiredMoveSpeed : float):
	desiredMoveSpeedLT.set_text(str(desiredMoveSpeed))

func displayVelocity(velocity : float):
	velocityLT.set_text(str(velocity))

func displayNbJumpsInAirAllowed(nbJumpsInAirAllowed : int):
	nbJumpsInAirAllowedLT.set_text(str(nbJumpsInAirAllowed))

func displayCurrentFPS():
	framesPerSecondLT.set_text(str(Engine.get_frames_per_second()))

func update_health(current: int) -> void:
	healthBar.value = current

func update_ammo(weapon):
	current_weapon = weapon
	if current_weapon != null:
		var mag_size = current_weapon.get("magazine_size")
		var cur_ammo = current_weapon.current_ammo
		if current_weapon.is_reloading:
			ammoLabel.text = "Recargando..."
		else:
			ammoLabel.text = str(cur_ammo, " / ", mag_size)
	else:
		ammoLabel.text = ""
