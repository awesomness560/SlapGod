extends Node2D
signal startPhase2
signal stopPhase2

@export var maxHealth : int = 100
var currentHealth : int = 100
@export var healthBar : TextureProgressBar
var increment : float = 0.3

@export var handSpawnRate : Timer
@onready var fistWaitTimer : Timer = $FistAttack/FistAttackTime
@onready var forceField : StaticBody2D = $ForceField
@onready var phaseOneVulnerability : Timer = $FistAttack/VulnerabiltyPhaseOne
@onready var hitbox : StaticBody2D = $Hitbox
@export var animation : AnimationPlayer

@onready var damagePhase : Timer = $"PhaseTwo/Damage Phase"

var phaseTwo : bool = false

var phaseTwoStarted : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = maxHealth
	await get_tree().create_timer(3).timeout
	startPhaseOne()
	get_parent().get_node("HandSpawning").process_mode = Node.PROCESS_MODE_PAUSABLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentHealth > healthBar.value:
		healthBar.value += increment
	elif currentHealth < healthBar.value:
		healthBar.value -= increment

func startPhaseOne():
	handSpawnRate.start()
	fistWaitTimer.start()
	forceField.process_mode = Node.PROCESS_MODE_PAUSABLE
	forceField.visible = true
	hitbox.set_collision_layer_value(1, false)
	hitbox.set_collision_mask_value(1, false)
	#Insert Animation Here

func pausePhaseOne():
	handSpawnRate.stop()
	forceField.process_mode = Node.PROCESS_MODE_DISABLED
	#Insert Animation Here
	forceField.visible = false
	phaseOneVulnerability.start()
	hitbox.set_collision_layer_value(1, true)
	hitbox.set_collision_mask_value(1, true)

func stopPhaseOne():
	handSpawnRate.stop()
	fistWaitTimer.stop()
	phaseOneVulnerability.stop()
	forceField.process_mode = Node.PROCESS_MODE_PAUSABLE
	forceField.visible = true
	animation.play("Phase2")
	get_parent().get_node("HandSpawning").process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(1).timeout
	startPhaseTwo()
	
func startPhaseTwo():
	startPhase2.emit()
	remove_from_group("focus")
	phaseTwoStarted = true

func pausePhaseTwo():
	add_to_group("focus")
	stopPhase2.emit()
	forceField.process_mode = Node.PROCESS_MODE_DISABLED
	forceField.visible = false
	damagePhase.start()

func stopPhaseTwo():
	add_to_group("focus")
	stopPhase2.emit()
	phaseTwoStarted = false
	
func startPhaseThree():
	pass

func pausePhaseThree():
	pass

func endBossFight():
	pass

func damageBoss(damage : int):
	currentHealth -= damage

func _on_fist_attack_time_timeout():
	pausePhaseOne()


func _on_vulnerabilty_phase_one_timeout():
	if !phaseTwoStarted:
		startPhaseOne()
	else:
		startPhaseTwo()


func _on_damage_phase_timeout():
	startPhaseTwo()
	forceField.process_mode = Node.PROCESS_MODE_PAUSABLE
	forceField.visible = true
