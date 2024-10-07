extends Node2D
class_name LevelParent

var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene: PackedScene = preload("res://scenes/projectiles/grenade.tscn")
var item_scene: PackedScene = preload('res://scenes/Items/item.tscn')


func _ready():
	for container in get_tree().get_nodes_in_group("Container"):
		container.connect('open',on_container_opened)
	for scout in get_tree().get_nodes_in_group("Scouts"):
		scout.connect("laser", _on_scout_laser)

func on_container_opened(pos ,direction):
	var item = item_scene.instantiate()
	item.position = pos
	item.direction = direction
	$Items.call_deferred("add_child",item)
	

func _on_player_laser_shot(pos,direction):
	create_laser(pos,direction)

func create_laser(pos,direction):
	var laser = laser_scene.instantiate()
	laser.position = pos
	laser.direction = direction
	laser.rotation_degrees = rad_to_deg(direction.angle())+90
	$Projectiles.add_child(laser)

func _on_player_grenade_used(pos,direction):
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity = direction * grenade.speed
	$Projectiles.add_child(grenade)
	
func _on_scout_laser(pos,direction):
	create_laser(pos,direction)

