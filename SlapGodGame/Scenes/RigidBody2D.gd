extends RigidBody2D


@export var empty_cursor : Texture
@export var hit_force : float = 50.0
@export var speed : float = 50.0
var previousMousePosition : Vector2 = Vector2(0,0)

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)
	pass

func _physics_process(delta):
	linear_velocity = (get_global_mouse_position() - global_transform.origin) * speed
	#if(previousMousePosition != get_global_mouse_position()):
	#	var dir = global_position.direction_to(get_global_mouse_position())
	#	apply_impulse(dir * hit_force)
	#elif(position != get_global_mouse_position()):
	#	move_and_collide(get_global_mouse_position() - global_position)
	#previousMousePosition = get_global_mouse_position()
