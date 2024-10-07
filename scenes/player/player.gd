extends CharacterBody2D

var can_laser: bool = true
var can_grenade: bool = true

signal laser_shot(pos,direction)
signal grenade_used(pos,direction)

@export var max_speed: int = 500
var speed: int = max_speed

func hit():
	Globals.health -= 10

func _process(_delta):
	
	#input
	var direction = Input.get_vector("left", "right", 'up' , "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	#rotate
	look_at(get_global_mouse_position())
	var player_direction = (get_global_mouse_position() - position).normalized()
	#laser shooting input
	if Input.is_action_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		$GPUParticles2D.emitting = true
		# randomly selected a marker 2D for the laser start
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		$Timer_Laser.start()
		laser_shot.emit(selected_laser.global_position,player_direction)
		
		
	#grenade throwing input
	if Input.is_action_pressed("secondary action") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		var pos = $GrenadeStartPositions.get_children()[0].global_position
		can_grenade  = false
		$Timer_Grenade.start()
		grenade_used.emit(pos,player_direction)


func _on_timer_laser_timeout():
	can_laser = true


func _on_timer_grenade_timeout():
	can_grenade = true
