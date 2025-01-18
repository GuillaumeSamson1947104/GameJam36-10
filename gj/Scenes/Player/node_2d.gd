extends CharacterBody2D
@export var jumpspeed : float = -600
@export var speed : float = 400
const  GRAVITY = 900
var start_timer

func _physics_process(delta):
	var direction = Input.get_axis("move_left","move_right")
	
	if direction:
		velocity.x = direction * speed
		
	else:
		velocity.x = 0
		
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jumpspeed
			
		else:
			pass
	
	move_and_slide()


func calculate_jump():
	if Input.is_action_just_pressed("jump"):
		start_timer.get_ticks_msec()
		
	if Input.is_action_just_released("jump"):
		var end_timer
		#end_time.get_ticks_msec()
		var total_time = end_timer - start_timer
		print(total_time)

func _unhandled_input(event):
	inputs(event)	
	
	
func inputs(event):
	if Input.is_action_just_pressed("jump"):
		print("jump")
