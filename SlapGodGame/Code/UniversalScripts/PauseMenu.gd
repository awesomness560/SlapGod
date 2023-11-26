extends CanvasLayer
signal paused(pauseState : bool)

@export var menu : PackedScene
var isPaused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkForPause()
	if Input.is_action_just_pressed("mainMenu"):
		print("Menu Pressed")
		get_tree().change_scene_to_packed(menu)

func checkForPause():
	if Input.is_action_just_pressed("Pause") && !isPaused:
		pause(true)
		$PauseMenu.visible = true
		isPaused = true
	elif Input.is_action_just_pressed("Pause") && isPaused:
		isPaused = false
		pauseMenu()

func pause(pause : bool):
	paused.emit(pause)
	get_tree().paused = pause
	get_parent().get_node("CanvasCursor").visible = pause
	get_parent().get_node("Game/Cursor").visible = !pause
	
func pauseMenu() -> void:
	print("Pause Menu")
	pause(false)
	paused.emit(false)
	$PauseMenu.visible = false
