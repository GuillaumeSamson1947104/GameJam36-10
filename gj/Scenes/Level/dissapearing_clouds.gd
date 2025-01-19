extends TileMapLayer

var buffer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = Time.get_ticks_msec()
	if ((time - (time % 1000)) % 3000) == 0 :
		if(buffer): return
		collision_enabled = !collision_enabled
		visible = !visible
		buffer = true
	else :
		buffer = false
		
