extends RigidBody2D
signal scored
signal airTimeFail
signal velocity(speed : Vector2)
@onready var fire1 : GPUParticles2D = $Fire1
@onready var fire2 : GPUParticles2D = $Fire2
@onready var smoke : GPUParticles2D = $Smoke

var entered : bool = true
@export var max_speed = 100
@export var mat : PhysicsMaterial
var bounce : float


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


func _on_body_exited(body):
	if body.is_in_group("Player"):
		await get_tree().create_timer(0.1).timeout
		mat.absorbent = false
		mat.bounce = bounce

func particles(state : bool):
	fire1.emitting = state
	fire2.emitting = state
	smoke.emitting = state
