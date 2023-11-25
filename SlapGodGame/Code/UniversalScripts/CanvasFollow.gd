extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = get_parent().get_parent().position
	#rotation = get_parent().get_parent().rotation
	position = get_global_mouse_position()
	rotation = get_parent().get_parent().get_node("Game/Cursor").rotation
