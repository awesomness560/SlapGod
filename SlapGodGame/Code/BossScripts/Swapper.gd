extends Node
signal swap(swapped : RigidBody2D)

@export var cursorsPossible : Array[RigidBody2D]
var cursors : Array[RigidBody2D]
var currentStep : int = 0
var previousStep : int = 0

@export var fireCursorUnlocked : bool = false
@export var earthCursorUnlocked : bool = false
@export var waterCursorUnlocked : bool = false
@export var airCursorUnlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for cursor in cursorsPossible:
		var name = cursor.name
		cursor.visible = false
		if name == "AirCursor" && airCursorUnlocked:
			cursors.append(cursor)
		elif name == "EarthCursor" && earthCursorUnlocked:
			cursors.append(cursor)
		elif name == "FireCursor" && fireCursorUnlocked:
			cursors.append(cursor)
			cursor.visible = true
		elif name == "WaterCursor" && waterCursorUnlocked:
			cursors.append(cursor)
	currentStep = 0
	previousStep = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	previousStep = currentStep
	if Input.is_action_just_pressed("WheelUp"):
		currentStep += 1
	elif Input.is_action_just_pressed("WheelDown"):
		currentStep -= 1
	if currentStep < 0:
		currentStep = cursors.size() - 1
	elif currentStep > cursors.size() - 1:
		currentStep = 0
	for cursor in cursors:
		if cursor != cursors[currentStep]:
			cursor.position = cursors[currentStep].position
	if currentStep != previousStep:
		setCursor(currentStep, previousStep)
	#print("Current Step " + str(currentStep))
	#print("Previous Step: " + str(previousStep))
	
func setCursor(index : int, previousIndex : int):
	cursors[previousIndex].visible = false
	cursors[previousIndex].process_mode = Node.PROCESS_MODE_DISABLED
	cursors[index].process_mode = Node.PROCESS_MODE_ALWAYS
	cursors[index].visible = true
	swap.emit(cursors[index])
	
func setCursorAlone(index : int):
	cursors[index].process_mode = Node.PROCESS_MODE_ALWAYS
	cursors[index].get_node("Sprite2D").visible = true
