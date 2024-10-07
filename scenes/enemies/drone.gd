extends CharacterBody2D

var is_enemy: bool = true
var active:bool = false
var vulnerable : bool = true
var health : int = 50
var max_speed: int = 400
var speed: int = 0
var speed_multiplier : int = 1
var explosion_active : bool = false
func _process(delta):
	if active:
		look_at(Globals.player_pos)
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed * speed_multiplier
		var collision = move_and_collide(velocity* delta)
		if collision:
			$AnimationPlayer.play("Explosion")
			explosion_active = true
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < 400
			if in_range and "hit" in target:
				target.hit()
func _ready():
	$Explosion.hide()
	$DroneImage.show()

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$DroneImage.material.set_shader_parameter("progress", 1)
		$HitTimer.start()
	if health<= 0:
		$AnimationPlayer.play("Explosion")
		await $AnimationPlayer.animation_finished
		queue_free()
		explosion_active = true
	
func stop_movement():
	speed_multiplier = 0


func _on_notice_area_body_entered(_body):
	active = true
	var tween = create_tween()
	tween.tween_property(self, "speed",max_speed,6)


func _on_hit_timer_timeout():
	vulnerable = true
	$DroneImage.material.set_shader_parameter("progress", 0)
	
