extends CharacterBody2D
@export var jumpspeed : float = -600
@export var speed : float = 400
const  GRAVITY = 3000
var start_timer 
var total_time
var player_direction
func _process(delta):
	inputs()
	print(player_direction)
	calculate_jump()
	#print(rotation_degrees)
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	
	move_and_slide()

func calculate_jump():
	if is_on_floor():
		
		if Input.is_action_just_pressed("jump"):
			start_timer = Time.get_ticks_msec()
		
		if Input.is_action_just_released("jump"):
			var end_timer = Time.get_ticks_msec()
		
			total_time = start_timer - end_timer
			var jump_strength = clamp(total_time, -3000, -200)
		
			velocity.y = jump_strength
		
			if player_direction == 1:
				velocity.x = jump_strength * -1
			elif player_direction == -1:
				velocity.x = jump_strength * 1
			else:
				velocity.x = 0
		
	
	#var jump_strength = clamp(total_time, 200, 2000)
	
	#velocity = jump_strength

func _unhandled_input(event):
	pass
	#inputs(event)
	
func inputs():
	
	var direction = Input.get_axis("move_left","move_right")
	if direction != 0:
		player_direction = direction
	# MOVEMENT
	if direction:
		velocity.x = direction * speed
		
	elif is_on_floor():
		velocity.x = 0
		
	# ROTATION
	if direction == 1:
		rotation_degrees = 90
	if direction == -1:
		rotation_degrees = -90

	
