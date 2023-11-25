extends StaticBody2D

@export var tin : int = 0
@export var tout : int = 0
var thalf
var win = DisplayServer.window_get_size()
var shape
var shapeowner

func _ready():
	thalf = (tin + tout) /2
	for extpos in [
			[Vector2(win.x/2, thalf), Vector2(win.x/2, win.y + thalf - tin)],  #bottom
			]:
		shape = RectangleShape2D.new()
		shape.extents = extpos[0]
		shapeowner = create_shape_owner(self)
		shape_owner_set_transform(shapeowner, Transform2D(0, extpos[1]))
		shape_owner_add_shape(shapeowner, shape)
