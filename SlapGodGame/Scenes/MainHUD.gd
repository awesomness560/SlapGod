extends CanvasLayer
signal paused(paused : bool)
signal fireballUnlock
signal fireballDuration
signal fireBurnRate
signal fireCooldown
signal fireInferno

var score : int = 0
var scoreTracker : int = 0
var multiplier : int = 1
var menuOnScreen : bool = false
var damageMenuOnScreen : bool = false
var slaps : int = 1
@export var multiplierCost : Array = [100, 500, 1000]
@export var slapsCost : int = 10
@export var slapsMultiplier : float = 1.2
@export var ball : RigidBody2D
@export var airTimeMultiplierAddition : float = 0.2
@export var speedDivider : float = 500
@export var costOfFireball : int = 30
@export var costOfDuration : int = 30
@export var costOfBurnRate : int = 30
@export var costOfCooldown : int = 30
@export var costOfInferno : int = 30
@onready var ability1button : Button = $DamageMenu/Fireball/BuyFireball
var airTimeMultiplier : float = 1
var multiplierCostStep : int = 0
var bodies
var speedMultiplier : float = 1

@onready var ability1Button : Button = $DamageMenu/Fireball/BuyAbility1
# Called when the node enters the scene tree for the first time.
func _ready():
	$Score/ScoreLabel.text = str(score)
	$UpgradeMenu/MultiplierCost.text = "Cost: " + str(multiplierCost[multiplierCostStep])
	multiplierCostStep += 1
	$UpgradeMenu/SlapsCost.text = "Cost: " + str(slapsCost)
	setCosts()
	$AnimationPlayer.play("MoveMenu")
	await get_tree().create_timer(0.01).timeout
	$AnimationPlayer.pause()
	
	#Font sizing was not working so I made a band-aid fix
	$DamageMenu/FireInferno/BuyInferno.add_theme_font_size_override("font_size", 55)
	$DamageMenu/FireBurnRate/UpgradeBurnRate.add_theme_font_size_override("font_size", 55)
	$DamageMenu/FireCooldown/BuyCooldown.add_theme_font_size_override("font_size", 55)
	$DamageMenu/FireballDuration/BuyDuration.add_theme_font_size_override("font_size", 55)
	$"UpgradeMenu/Upgrade Slaps".add_theme_font_size_override("font_size", 55)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkForUpgradeMenu()
	#checkForDamageMenu()
	if damageMenuOnScreen or menuOnScreen:
		pause(true)
	else:
		pause(false)
	
	if ball.get_colliding_bodies().is_empty():
		await $AirTimeMultiplier/Timer.timeout
		$AirTimeMultiplier/AirAnimation.play("AirTimeFill")
	else:
		$AirTimeMultiplier/AirAnimation.pause()
	
func scored():
	if scoreTracker > 1:
		score -= slaps * multiplier
		scoreTracker = 0
	var multipliers = airTimeMultiplier + speedMultiplier
	score += round((slaps * multipliers) * multiplier)
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
	
func setCosts() -> void:
	$DamageMenu/Fireball/BuyCostFireball.text = "Cost: " + str(costOfFireball)
	$DamageMenu/FireballDuration/FireballDurationCost.text = "Cost: " + str(costOfDuration)
	$DamageMenu/FireCooldown/FireCooldownCost.text = "Cost: " + str(costOfCooldown)
	$DamageMenu/FireballDuration/FireballDurationCost.text = "Cost: " + str(costOfDuration)
	$DamageMenu/FireInferno/InfernoCost.text = "Cost: " + str(costOfInferno)
	
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

func _on_circle_velocity(speed):
	speedMultiplier = abs(snapped(speed.x / speedDivider, 0.1))
	$SpeedMultiplier.text = "Speed Multiplier: " + str(speedMultiplier) + "x"
	$SpeedMultiplier/SpeedMultiAnimator.play("SpeedAnimation")
	await get_tree().create_timer(0.5).timeout
	$SpeedMultiplier.text = "Speed Multiplier: 1.0x"
	
func pause(pause : bool):
	paused.emit()
	get_tree().paused = pause
	get_parent().get_node("CanvasCursor").visible = pause
	get_parent().get_node("Game/Cursor").visible = !pause
	
func checkForUpgradeMenu() -> void:
	if Input.is_action_just_pressed("Upgrade Menu") && menuOnScreen:
		menuOnScreen = false
		$AnimationPlayer.play_backwards("MoveMenu")
		$AirTimeMultiplier.visible = true
		$SpeedMultiplier.visible = true
#		$UpgradeMenu/MenuAnimator.play_backwards("UpgradeMenu")
	elif Input.is_action_just_pressed("Upgrade Menu") && !menuOnScreen:
		menuOnScreen = true
		$AnimationPlayer.play("MoveMenu")
		$AirTimeMultiplier.visible = false
		$SpeedMultiplier.visible = false
#		$UpgradeMenu/MenuAnimator.play("UpgradeMenu")
		
func checkForDamageMenu() -> void:
	if Input.is_action_just_pressed("Damage Menu") && damageMenuOnScreen:
		damageMenuOnScreen = false
#		$DamageMenu/MenuAnimator.play_backwards("DamageMenu")
	elif Input.is_action_just_pressed("Damage Menu") && !damageMenuOnScreen:
		damageMenuOnScreen = true
#		$DamageMenu/MenuAnimator.play("DamageMenu")

func _on_buy_ability_1_pressed():
	if score >= costOfFireball:
		fireballUnlock.emit()
		buyFromScore(costOfFireball)
		$DamageMenu/Fireball/BuyFireball.disabled = true
		$DamageMenu/Fireball/BuyFireball.text = "Bought"
		$DamageMenu/Fireball/BuyCostFireball.visible = false
		$DamageMenu/Fireball/BuyCostFireball/MultiplierCostAnimations.play("CostGreen")
	else:
		$DamageMenu/Fireball/BuyCostFireball/MultiplierCostAnimations.play("CostRed")


func _on_buy_duration_pressed():
	if score >= costOfFireball:
		fireballDuration.emit()
		buyFromScore(costOfDuration)
		$DamageMenu/FireballDuration/BuyDuration.disabled = true
		$DamageMenu/FireballDuration/BuyDuration.text = "Bought"
		$DamageMenu/FireballDuration/FireballDurationCost.visible = false
		$DamageMenu/FireballDuration/FireballDurationCost/SlapsCostAnimator.play("CostGreen")
	else:
		$DamageMenu/FireballDuration/FireballDurationCost/SlapsCostAnimator.play("CostRed")


func _on_upgrade_burn_rate_pressed():
	if score >= costOfFireball:
		fireBurnRate.emit()
		buyFromScore(costOfBurnRate)
		$DamageMenu/FireBurnRate/UpgradeBurnRate.disabled = true
		$DamageMenu/FireBurnRate/UpgradeBurnRate.text = "Bought"
		$DamageMenu/FireBurnRate/FireBurnRateCost.visible = false
		$DamageMenu/FireBurnRate/FireBurnRateCost/SlapsCostAnimator.play("CostGreen")
	else:
		$DamageMenu/FireBurnRate/FireBurnRateCost/SlapsCostAnimator.play("CostRed")


func _on_buy_cooldown_pressed():
	if score >= costOfFireball:
		fireCooldown.emit()
		buyFromScore(costOfCooldown)
		$DamageMenu/FireCooldown/BuyCooldown.disabled = true
		$DamageMenu/FireCooldown/BuyCooldown.text = "Bought"
		$DamageMenu/FireCooldown/FireCooldownCost.visible = false
		$DamageMenu/FireCooldown/FireCooldownCost/SlapsCostAnimator.play("CostGreen")
	else:
		$DamageMenu/FireCooldown/FireCooldownCost/SlapsCostAnimator.play("CostRed")


func _on_buy_inferno_pressed():
	if score >= costOfFireball:
		fireInferno.emit()
		buyFromScore(costOfInferno)
		$DamageMenu/FireInferno/BuyInferno.disabled = true
		$DamageMenu/FireInferno/BuyInferno.text = "Bought"
		$DamageMenu/FireInferno/InfernoCost.visible = false
		$DamageMenu/FireInferno/InfernoCost/SlapsCostAnimator.play("CostGreen")
	else:
		$DamageMenu/FireInferno/InfernoCost/SlapsCostAnimator.play("CostRed")
