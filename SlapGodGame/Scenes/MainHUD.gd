extends CanvasLayer

var score : int = 0
var scoreTracker : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func scored():
	if scoreTracker > 1:
		score -= 1
		scoreTracker = 0
	score += 1
	$ScoreLabel.text = str(score)
	scoreTracker += 1
