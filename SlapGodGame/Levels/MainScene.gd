extends Node2D

@export var Earth : PackedScene
@export var Air : PackedScene
@export var Fire : PackedScene
@export var Water : PackedScene
@export var Menu : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mainMenu"):
		get_tree().change_scene_to_packed(Menu)


func _on_earth_pressed():
	get_tree().change_scene_to_packed(Earth)


func _on_fire_pressed():
	get_tree().change_scene_to_packed(Fire)


func _on_water_pressed():
	get_tree().change_scene_to_packed(Water)


func _on_air_pressed():
	get_tree().change_scene_to_packed(Air)
