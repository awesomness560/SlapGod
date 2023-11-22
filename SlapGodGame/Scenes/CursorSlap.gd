extends RigidBody2D

@export var empty_cursor : Texture
@export var hit_force : float = 50
var entered : bool = false
@export var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(get_global_mouse_position() - global_position)
