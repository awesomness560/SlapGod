extends Node
@onready var ball : RigidBody2D = $Circle
@export var walls : Array[StaticBody2D]
@onready var marker : Marker2D = $Marker2D

signal reset

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func phaseTwoStart():
	ball.add_to_group("focus")
	ball.visible = true
	ball.process_mode = Node.PROCESS_MODE_PAUSABLE
	reset.emit()
	for wall in walls:
		wall.process_mode = Node.PROCESS_MODE_PAUSABLE
		wall.visible = true
	
func phaseTwoEnd():
	ball.remove_from_group("focus")
	ball.visible = false
	ball.process_mode = Node.PROCESS_MODE_DISABLED
	for wall in walls:
		wall.process_mode = Node.PROCESS_MODE_DISABLED
		wall.visible = false

func restartBall():
	reset.emit()
