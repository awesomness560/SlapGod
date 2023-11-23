extends CanvasLayer

var score : int = 0
var scoreTracker : int = 0
var multiplier : int = 1
var menuOnScreen : bool = false
var slaps : int = 1
@export var multiplierCost : Array = [100, 500, 1000]
@export var slapsCost : int = 10
@export var slapsMultiplier : float = 1.2
@export var ball : RigidBody2D
@export var airTimeMultiplierAddition : float = 0.2
var airTimeMultiplier : float = 1
var multiplierCostStep : int = 0
var bodies

# Called when the node enters the scene tree for the first time.
func _ready():
	$Score/ScoreLabel.text = str(score)
	$UpgradeMenu/MultiplierCost.text = "Cost: " + str(multiplierCost[multiplierCostStep])
	multiplierCostStep += 1
	$UpgradeMenu/SlapsCost.text = "Cost: " + str(slapsCost)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Upgrade Menu") && menuOnScreen:
		$UpgradeMenu/MenuAnimator.play_backwards("UpgradeMenu")
		menuOnScreen = false
	elif Input.is_action_just_pressed("Upgrade Menu") && !menuOnScreen:
		$UpgradeMenu/MenuAnimator.play("UpgradeMenu")
		menuOnScreen = true
		
	if ball.get_colliding_bodies().is_empty():
		await $AirTimeMultiplier/Timer.timeout
		$AirTimeMultiplier/AirAnimation.play("AirTimeFill")
	else:
		$AirTimeMultiplier/AirAnimation.pause()
	
func scored():
	if scoreTracker > 1:
		score -= slaps * multiplier
		scoreTracker = 0
	score += round((slaps * airTimeMultiplier) * multiplier)
	$Score/ScoreLabel.text = str(score)
	$Score/ScoreAnimator.play("ScoreShake2")
	scoreTracker += 1

func _on_upgrade_pressed():
	if score >= multiplierCost[multiplierCostStep - 1]:
		addMultiplier()
		$UpgradeMenu/MultiplierCost/MultiplierCostAnimations.play("CostGreen")
	else:
		$UpgradeMenu/MultiplierCost/MultiplierCostAnimations.play("CostRed")

func _on_upgrade_slaps_pressed():
	if score >= slapsCost:
		addSlaps()
		$UpgradeMenu/SlapsCost/SlapsCostAnimator.play("CostGreen")
	else:
		$UpgradeMenu/SlapsCost/SlapsCostAnimator.play("CostRed")
	
func buyFromScore(minusScore : int) -> void:
	score -= minusScore
	if score < 0:
		score = 0
	$Score/ScoreLabel.text = str(score)
	$Score/ScoreAnimator.play("ScoreReduction")
	
func addSlaps():
	slaps += 1
	$UpgradeMenu/SlapsValue.text = "+ " + str(slaps)
	buyFromScore(slapsCost)
	slapsCost = int(round(slapsCost * slapsMultiplier))
	$UpgradeMenu/SlapsCost.text = "Cost: " + str(slapsCost)
	$UpgradeMenu/SlapsValue/SlapsAnimation.play("MultiplierUpgrade")
	await get_tree().create_timer(0.21).timeout
	$UpgradeMenu/SlapsValue/SlapsAnimation.play("MultiplierUpgrade") 
	
func addMultiplier() -> void:
	multiplier += 1
	$UpgradeMenu/MultiplierValue.text = str(multiplier) + ".0x"
	buyFromScore(multiplierCost[multiplierCostStep - 1])
	
	if multiplierCostStep <= multiplierCost.size() - 1:
		$UpgradeMenu/MultiplierCost.text = "Cost: " + str(multiplierCost[multiplierCostStep])
		multiplierCostStep += 1
	else:
		$"UpgradeMenu/Upgrade Multiplier".disabled = true
		$"UpgradeMenu/Upgrade Multiplier".text = "Max Level"
		$UpgradeMenu/MultiplierCost.hide()
	$UpgradeMenu/MultiplierValue/MultiplierAnimation.play("MultiplierUpgrade")
	await get_tree().create_timer(0.21).timeout
	$UpgradeMenu/MultiplierValue/MultiplierAnimation.play("MultiplierUpgrade")


func _on_air_animation_animation_finished(anim_name):
	airTimeMultiplier += airTimeMultiplierAddition
	$AirTimeMultiplier.text = "Air Time Multiplier: " + str(airTimeMultiplier) + "x"


func _on_circle_air_time_fail():
	airTimeMultiplier = 1
	$AirTimeMultiplier.text = "Air Time Multiplier: " + str(airTimeMultiplier) + "x"
