extends Node

@export var handScene : PackedScene
@export var speed : Vector2 = Vector2(350, 550)

const EMITTER = preload("res://Scenes/Hand.tscn")
const RECIVER = preload("res://Levels/HealthManager.gd")

@export var healthManager : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hand_spawn_rate_timeout():
	var mob = handScene.instantiate()
	mob.connect("hit", healthManager.decreaseHealth)

	# Choose a random location on Path2D.
	var mob_spawn_location = $HandPath/HandSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 6, PI / 6)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(speed.x, speed.y), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
