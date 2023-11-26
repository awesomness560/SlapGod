extends Area2D
@onready var collider : CollisionShape2D = $CollisionShape2D

const DESIRED_WIDTH = 400
const DESIRED_HEIGHT = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	#// Get the screen size
	var screen_size = DisplayServer.window_get_size()

#// Generate random positions for the top-left and bottom-right corners
	var top_left = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
	var bottom_right = Vector2(screen_size.x - top_left.x, screen_size.y - top_left.y)

#// Calculate the width and height of the rectangle
	var width = DESIRED_WIDTH / abs(bottom_right.x - top_left.x)
	var height = DESIRED_HEIGHT / abs(bottom_right.y - top_left.y)

#// Create an Area2D node
	var area2d = Area2D.new()

#// Set the Area2D position and size
	position = top_left
	scale = Vector2(width, height)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#// Get the screen size
	#var screen_size = DisplayServer.window_get_size()
#
##// Generate a random position for the Area2D
	#var random_position = Vector2(0, randf_range(0, screen_size.y))
#
##// Calculate the endpoint of the diagonal line
	#var endpoint = Vector2(screen_size.x - random_position.x, screen_size.y - random_position.y)
##
##// Calculate the distance between the position and endpoint
	#var distance = endpoint.distance_to(random_position)
##// Calculate the hypotenuse using the Pythagorean theorem
	#var hypotenuse = sqrt(random_position.length() * random_position.length() + (screen_size / 2).length() * (screen_size / 2).length())
#
	##// Calculate the scale factor
	#var scale = hypotenuse / random_position.length()
##
##// Rotate the Area2D to align with the diagonal line
	#var rotation_angle = endpoint.angle_to(random_position)
##
##// Set the Area2Ds position, scale, and rotation
	#collider.transform = Transform2D(rotation_angle, Vector2(scale, scale), 0, random_position)
