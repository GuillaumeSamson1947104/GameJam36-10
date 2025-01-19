extends Node2D



func _on_lightning_timeout():
	#$DirectionalLight2D.set_energy(0)
	$DirectionalLight2D.set_enabled(1)
	await get_tree().create_timer(.5).timeout
	$DirectionalLight2D.set_enabled(0)
	await get_tree().create_timer(.2).timeout
	$DirectionalLight2D.set_enabled(1)
	await get_tree().create_timer(.2).timeout
	$DirectionalLight2D.set_enabled(0)
	
