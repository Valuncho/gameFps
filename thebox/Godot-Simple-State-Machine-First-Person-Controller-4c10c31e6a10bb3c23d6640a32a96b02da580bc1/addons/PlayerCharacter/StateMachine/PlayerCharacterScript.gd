extends CharacterBody3D

class_name PlayerCharacter 

@export_group("Movement variables")
var moveSpeed : float
var moveAccel : float
var moveDeccel : float
var desiredMoveSpeed : float 
@export var desiredMoveSpeedCurve : Curve
@export var maxSpeed : float
@export var inAirMoveSpeedCurve : Curve
var inputDirection : Vector2 
var moveDirection : Vector3 
@export var hitGroundCooldown : float #amount of time the character keep his accumulated speed before losing it (while being on ground)
var hitGroundCooldownRef : float 
@export var bunnyHopDmsIncre : float #bunny hopping desired move speed incrementer
@export var autoBunnyHop : bool = false
var lastFramePosition : Vector3 
var lastFrameVelocity : Vector3
var wasOnFloor : bool
var walkOrRun : String = "WalkState" #keep in memory if play char was walking or running before being in the air
#for crouch visible changes
@export var baseHitboxHeight : float
@export var baseModelHeight : float
@export var heightChangeSpeed : float

@export_group("Crouch variables")
@export var crouchSpeed : float
@export var crouchAccel : float
@export var crouchDeccel : float
@export var continiousCrouch : bool = false #if true, doesn't need to keep crouch button on to crouch
@export var crouchHitboxHeight : float
@export var crouchModelHeight : float

@export_group("Walk variables")
@export var walkSpeed : float
@export var walkAccel : float
@export var walkDeccel : float

@export_group("Run variables")
@export var runSpeed : float
@export var runAccel : float 
@export var runDeccel : float 
@export var continiousRun : bool = false #if true, doesn't need to keep run button on to run

@export_group("Jump variables")
@export var jumpHeight : float
@export var jumpTimeToPeak : float
@export var jumpTimeToFall : float
@onready var jumpVelocity : float = (2.0 * jumpHeight) / jumpTimeToPeak
@export var jumpCooldown : float
var jumpCooldownRef : float 
@export var nbJumpsInAirAllowed : int 
var nbJumpsInAirAllowedRef : int 
var jumpBuffOn : bool = false
var bufferedJump : bool = false
@export var coyoteJumpCooldown : float
var coyoteJumpCooldownRef : float
var coyoteJumpOn : bool = false

@export_group("Gravity variables")
@onready var jumpGravity : float = (-2.0 * jumpHeight) / (jumpTimeToPeak * jumpTimeToPeak)
@onready var fallGravity : float = (-2.0 * jumpHeight) / (jumpTimeToFall * jumpTimeToFall)

@export_group("Keybind variables")
@export var moveForwardAction : String = ""
@export var moveBackwardAction : String = ""
@export var moveLeftAction : String = ""
@export var moveRightAction : String = ""
@export var runAction : String = ""
@export var crouchAction : String = ""
@export var jumpAction : String = ""

#references variables
@onready var camHolder : Node3D = $CameraHolder
@onready var model : MeshInstance3D = $Model
@onready var hitbox : CollisionShape3D = $Hitbox
@onready var stateMachine : Node = $StateMachine
@onready var hud : CanvasLayer = $HUD
@onready var ceilingCheck : RayCast3D = $Raycasts/CeilingCheck
@onready var floorCheck : RayCast3D = $Raycasts/FloorCheck

# -- Manejo de armas --
@onready var weapon_slot_1: Node3D = $CameraHolder/Camera/WeaponSlot1
@onready var weapon_slot_2: Node3D = $CameraHolder/Camera/WeaponSlot2

@export var starting_weapon_scene: PackedScene  # arma inicial (ej: pistola)
@export var second_weapon_scene: PackedScene    # segunda arma (ej: rifle)

var weapons = [null, null]  # Array para guardar armas en slot 0 y 1
var current_weapon: WeaponBase = null
var current_slot_index: int = 0

func _ready():
	#set move variables, and value references
	moveSpeed = walkSpeed
	moveAccel = walkAccel
	moveDeccel = walkDeccel
	
	hitGroundCooldownRef = hitGroundCooldown
	jumpCooldownRef = jumpCooldown
	nbJumpsInAirAllowedRef = nbJumpsInAirAllowed
	coyoteJumpCooldownRef = coyoteJumpCooldown
	
	# Inicializar vida y actualizar HUD
	current_health = max_health
	hud.update_health(current_health)
	add_to_group("PlayerCharacter")
	
	# -- Instanciar armas y configurar --
	# Instanciar arma 1 y agregar al slot 1
	var weapon1 = starting_weapon_scene.instantiate()
	weapon_slot_1.add_child(weapon1)
	weapons[0] = weapon1

	# PASAR LA REFERENCIA DE LA CÁMARA
	weapon1.set_camera(camHolder.get_node("Camera"))

	weapon1.equip()
	weapon1.visible = true

	# Lo mismo para arma 2
	var weapon2 = second_weapon_scene.instantiate()
	weapon_slot_2.add_child(weapon2)
	weapons[1] = weapon2

	weapon2.set_camera(camHolder.get_node("Camera"))

	weapon2.unequip()
	weapon2.visible = false

	current_slot_index = 0
	current_weapon = weapon1


func _process(_delta: float):
	displayProperties()
	
	# Delega el input al arma actual
	if current_weapon:
		current_weapon.handle_input()

	# Cambiar arma con teclas (ejemplo: 1 y 2)
	if Input.is_action_just_pressed("weapon_1"):
		switch_weapon(0)
	elif Input.is_action_just_pressed("weapon_2"):
		switch_weapon(1)



func _physics_process(_delta : float):
	modifyPhysicsProperties()
	move_and_slide()


func displayProperties():
	#display properties on the hud
	if hud != null:
		hud.displayCurrentState(stateMachine.currStateName)
		hud.displayDesiredMoveSpeed(desiredMoveSpeed)
		hud.displayVelocity(velocity.length())
		hud.displayNbJumpsInAirAllowed(nbJumpsInAirAllowed)
		

func modifyPhysicsProperties():
	lastFramePosition = position #get play char position every frame
	lastFrameVelocity = velocity #get play char velocity every frame
	wasOnFloor = !is_on_floor() #check if play char was on floor every frame
	

func gravityApply(delta : float):
	#if play char goes up, apply jump gravity
	#otherwise, apply fall gravity
	if velocity.y >= 0.0: velocity.y += jumpGravity * delta
	elif velocity.y < 0.0: velocity.y += fallGravity * delta


#Codigo Valen

# Vida del Jugador
@export var max_health: int = 100
var current_health: int

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	print("Vida actual del jugador:", current_health)  # <-- para debug
	hud.update_health(current_health)
	if current_health <= 0:
		die()


func die():
	print("El jugador ha muerto.")
	# Aca podes reiniciar nivel, reproducir animacion, etc.


func _on_hitbox_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy_attack"):
		take_damage(10)  # o la cantidad que corresponda


# -- FUNCIONES NUEVAS para cambio de armas --

func switch_weapon(slot_index: int):
	if slot_index == current_slot_index:
		return  # ya está equipado
	
	if slot_index < 0 or slot_index >= weapons.size():
		return  # índice inválido
	
	# Desequipar arma actual
	if current_weapon:
		current_weapon.unequip()
		current_weapon.visible = false  # ocultar
	
	# Equipar arma nueva
	current_slot_index = slot_index
	current_weapon = weapons[slot_index]
	current_weapon.equip()
	current_weapon.visible = true
