extends RigidBody2D
signal scored
signal airTimeFail
signal velocity(speed : Vector2)
signal hit
signal restart

@export var bossFight : bool = false
@onready var fire1 : GPUParticles2D = $Fire1
@onready var fire2 : GPUParticles2D = $Fire2
@onready var smoke : GPUParticles2D = $Smoke

var entered : bool = true
@export var max_speed = 100
@export var mat : PhysicsMaterial
var bounce : float

var reset : bool = false


func _ready():
	bounce = mat.bounce



func _on_body_entered(body):
	if body.is_in_group("Player"):
		mat.bounce = 0
		mat.absorbent = true
		scored.emit()
		velocity.emit(linear_velocity)
	elif body.is_in_group("wall"):
		mat.bounce = bounce
		if body.is_in_group("floor"):
			airTimeFail.emit()
	if bossFight && body.is_in_group("forceField"):
		hit.emit()
	if bossFight && body.is_in_group("obstacle"):
		restart.emit()


func _on_body_exited(body):
	if body.is_in_group("Player"):
		await get_tree().create_timer(0.1).timeout
		mat.absorbent = false
		mat.bounce = bounce

func particles(state : bool):
	fire1.emitting = state
	fire2.emitting = state
	smoke.emitting = state

func _integrate_forces(state):
	if reset:
		state.transform = Transform2D(0, Vector2(151, 329))
		reset = false

func _on_phase_two_reset():
	reset = true
