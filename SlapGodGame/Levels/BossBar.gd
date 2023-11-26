extends Node
signal noHealth
signal phase2
signal phase3

@export var maxHealth : int = 100
var currentHealth : int = 100

@export var healthBar : TextureProgressBar
var increment : float = 0.3

@export var bossHideHealth2 : int = 10
@export var bossHealthRestore2 : int = 80
var phaseTwoStarted : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	healthBar.max_value = maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	healthBar.value = currentHealth
	if healthBar.value <= 0:
		noHealth.emit()
		print("Boss Died")
	if currentHealth <= bossHideHealth2 && !phaseTwoStarted:
		currentHealth = bossHealthRestore2
		phase2.emit()
		phaseTwoStarted = true
	#if currentHealth > healthBar.value:
		#print("Increment")
		##Insert Animation Here"res://Levels/BossBar.gd"
		#healthBar.value += increment
	#if currentHealth < healthBar.value:
		#print("Decreament")
		##Insert Animation Here
		#healthBar.value -= increment
		#print("Current Health: " +str(currentHealth))
		#print("Health bar: " + str(healthBar.value))
	#if currentHealth == healthBar.value:
		##Stop Animation Here
		#pass

func increaseHealth(health : int):
	healthBar.visible = true
	currentHealth += health
	if currentHealth > maxHealth:
		currentHealth = maxHealth

func decreaseHealth(health : int):
	healthBar.visible = true
	currentHealth -= health
	#Insert Animation Here
	if currentHealth <= 0:
		currentHealth = 0
