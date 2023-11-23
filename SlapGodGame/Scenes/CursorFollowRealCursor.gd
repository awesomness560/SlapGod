extends RigidBody2D

@export var hit_force : float = 50.0
var previousMousePosition : Vector2 = Vector2(0,0)
@export var empty_cursor : Texture
@export var stiffness = 50
@export var damping = 1

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)

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
