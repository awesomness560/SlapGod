extends Node

@export var maxHealth : int = 100
var currentHealth : int = 100

@onready var healthBar : TextureProgressBar = $HealthBar
@export var cursor : RigidBody2D
var localPos : Vector2
var increment : float = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	localPos = healthBar.position
	healthBar.max_value = maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	healthBar.global_position = cursor.global_position + localPos
	if healthBar.value == maxHealth:
		healthBar.visible = false
	else:
		healthBar.visible = true
	if currentHealth > healthBar.value:
		#Insert Animation Here
		healthBar.value += increment
	elif currentHealth < healthBar.value:
		healthBar.value -= increment
	if currentHealth == healthBar.value:
		#Stop Animation Here
		pass


func _on_swapper_swap(swapped):
	cursor = swapped

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
