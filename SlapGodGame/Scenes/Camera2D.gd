extends Camera2D

var menuOnScreen : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Upgrade Menu") && !menuOnScreen:
		$CameraAnimator.play("UpgradeMenu")
		menuOnScreen = true
	elif Input.is_action_just_pressed("Upgrade Menu") && menuOnScreen:
		$CameraAnimator.play_backwards("UpgradeMenu")
		menuOnScreen = false
