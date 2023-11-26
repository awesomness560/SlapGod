extends RigidBody2D
signal hit(damage : int)

const EMITTER = preload("res://Scenes/Hand.tscn")
const RECIVER = preload("res://Levels/HealthManager.gd")
@export var damage : int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		hit.emit(damage)


func _on_despawn_timer_timeout():
	queue_free()
