extends RigidBody2D
signal slap
signal fire(state : bool)
signal inferno

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
@export var fireBurnRateChange : float = 0.25
var infernoUnlcoked : bool = false
var canUse : bool = true
var fireballUsing : bool = false
var onCooldown : bool = false
var infernoOnCooldown : bool = false
var isUsingInferno : bool = false
var infernoTimerStarted : bool = false
var ballEntered : bool = false
var fireballUnlcoked = false

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)
	cooldownProgress.value = 0
	cooldown.wait_time = cooldownProgress.value
	$FireInferno.monitoring = false
	$FireInferno/AnimatedSprite2D.play("new_animation")

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
	elif Input.is_action_just_pressed("Ability Trigger") && infernoUnlcoked && !isUsingInferno:
		if !infernoOnCooldown:
			isUsingInferno = true
			$FireInferno/AnimatedSprite2D.visible = true
			duration.start()
	if ballEntered && infernoUnlcoked && !infernoOnCooldown && isUsingInferno && !infernoTimerStarted:
		print("Start Timer")
		$FireInfernoTimer.start()
		infernoTimerStarted = true
			
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
	infernoOnCooldown = true
	isUsingInferno = false
	$FireInferno/AnimatedSprite2D.visible = false
	$FireInfernoTimer.stop()
	infernoTimerStarted = false
	cooldown.start()

func _on_slap_speed_timeout():
	if !onCooldown && fireballUsing:
		slap.emit()
		slap.emit()

func _on_cooldown_timeout():
	onCooldown = false
	infernoOnCooldown = false

func _on_main_hud_fireball():
	fireballUnlcoked = true


func _on_main_hud_fireball_duration():
	$Duration.wait_time += fireDurationIncrease

func _on_main_hud_fire_cooldown():
	$Cooldown.wait_time -= fireCooldownDecrease

func _on_main_hud_fire_burn_rate():
	$SlapSpeed.wait_time = fireBurnRateChange

func _on_fire_inferno_body_entered(body):
	if body.is_in_group("ball"):
		ballEntered = true

func _on_fire_inferno_body_exited(body):
	if body.is_in_group("ball") && infernoUnlcoked:
		ballEntered = false
		$FireInfernoTimer.stop()
		infernoTimerStarted = false

func _on_fire_inferno_timer_timeout():
	print("Timeout")
	slap.emit()
	slap.emit()
	infernoTimerStarted = false

func _on_main_hud_fire_inferno():
	infernoUnlcoked = true
	$FireInferno.monitoring = true
	$FireInferno.get
	fireballUnlcoked = false
	for body in $FireInferno.get_overlapping_bodies():
		if body.is_in_group("ball"):
			ballEntered = true
	inferno.emit()
	stopFireball()
