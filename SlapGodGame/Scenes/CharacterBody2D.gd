extends CharacterBody2D

@export var empty_cursor : Texture

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)
	
func _process(delta):
	move_and_collide(get_global_mouse_position() - global_position)
