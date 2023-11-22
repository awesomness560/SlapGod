extends RigidBody2D
signal scored

var entered : bool = true
@export var max_speed = 100
@export var mat : PhysicsMaterial
var bounce : float


func _ready():
	bounce = mat.bounce
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("Absorbent: " + str(mat.absorbent))
	print("Bounce: " + str(mat.bounce))



func _on_body_entered(body):
	if body.is_in_group("Player"):
		mat.bounce = 0
		mat.absorbent = true
		scored.emit()
	elif body.is_in_group("wall"):
		mat.bounce = bounce


func _on_body_exited(body):
	if body.is_in_group("Player"):
		await get_tree().create_timer(0.1).timeout
		mat.absorbent = false
		mat.bounce = bounce
