extends RigidBody2D
signal scored

var starting_position : Transform2D
var screen_size
var score : int = 0
var entered : bool = true
@export var max_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	starting_position = transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = position.clamp(Vector2.ZERO, screen_size)
	pass



func _on_body_entered(body):
	if body.is_in_group("Player"):
		if entered == true:
			scored.emit()
			entered = false


func _on_body_exited(body):
	entered = true
