extends RigidBody2D
signal scored

@export var hit_force : float = 50
var entered : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entered:
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#	var dir = -global_position.direction_to(get_global_mouse_position())
		#	apply_impulse(dir * hit_force)
		if Input.is_action_just_pressed("Slap"):
			var dir = -global_position.direction_to(get_global_mouse_position())
			apply_impulse(dir * hit_force)
			scored.emit()


func _on_circle_mouse_entered():
	entered = true


func _on_mouse_exited():
	entered = false
