extends RigidBody2D
signal slap
signal fire(state : bool)

@export var hit_force : float = 50.0
var previousMousePosition : Vector2 = Vector2(0,0)
@export var empty_cursor : Texture
@export var stiffness = 50
@export var damping = 1
@onready var duration : Timer = $Duration
@onready var cooldown : Timer = $Cooldown
@onready var slapSpeed : Timer = $SlapSpeed
@onready var cooldownProgress : TextureProgressBar = $CooldownBar
@export var fireDurationIncrease : int = 4
@export var fireCooldownDecrease : int = 2
@export var fireBurnRateChange : int = 0.25
var canUse : bool = true
var fireballUsing : bool = false
var onCooldown : bool = false
var fireballUnlcoked = false

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)
	cooldownProgress.value = 0
	cooldown.wait_time = cooldownProgress.value

func _physics_process(delta):
	#if(previousMousePosition != get_global_mouse_position()):
	#	var dir = global_position.direction_to(get_global_mouse_position())
	#	apply_impulse(dir * hit_force)
	#else:
	var x = get_global_mouse_position() - global_position
	var spring_force = (x *stiffness) - (linear_velocity * damping)
	apply_central_force(spring_force * mass)
	#previousMousePosition = get_global_mouse_position()
	
func _integrate_forces(state):
	set_angular_velocity((get_angle_to(get_parent().get_node("Circle").global_position)) * -((get_angle_to(get_parent().get_node("Circle").global_position)) -3.14) * 5)
	
func _process(delta):
	if onCooldown:
		var divisor = 100 / cooldown.wait_time
		cooldownProgress.value = cooldown.time_left * divisor
	if Input.is_action_just_pressed("Ability Trigger") && fireballUnlcoked:
		if !onCooldown && !fireballUsing:
			useFireball()
			
func useFireball() -> void:
	duration.start()
	fireballUsing = true
	fire.emit(true)
func stopFireball() -> void:
	cooldown.start()
	fireballUsing = false
	onCooldown = true
	fire.emit(false)

func _on_duration_timeout():
	stopFireball()

func _on_slap_speed_timeout():
	if !onCooldown && fireballUsing:
		slap.emit()
		slap.emit()

func _on_cooldown_timeout():
	onCooldown = false

func _on_main_hud_fireball():
	fireballUnlcoked = true


func _on_main_hud_fireball_duration():
	$Duration.wait_time += fireDurationIncrease

func _on_main_hud_fire_cooldown():
	$Cooldown.wait_time -= fireCooldownDecrease

func _on_main_hud_fire_burn_rate():
	$SlapSpeed.wait_time = fireBurnRateChange
