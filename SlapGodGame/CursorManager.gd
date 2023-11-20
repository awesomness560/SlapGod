extends CanvasLayer


@export var empty_cursor : Texture

func _ready():
	#Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)
	
func _process(delta):
	global_position = get_global_mouse_position()
