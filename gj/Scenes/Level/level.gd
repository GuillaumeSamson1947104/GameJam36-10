extends Node2D
var current_level = 1


func _on_level_change_1_area_entered(area: Area2D) -> void:
	current_level == 2
	$"../ParallaxBackground/layer_1".set_visible(0)
	$"../ParallaxBackground/layer_1/background_1".set_visible(0)
		
	$"../ParallaxBackground/layer_2".set_visible(1)
	$"../ParallaxBackground/layer_2/background_2".set_visible(1)
		
	


func _on_level_change_2_area_entered(area: Area2D) -> void:
		current_level == 1
		
		$"../ParallaxBackground/layer_1".set_visible(1)
		$"../ParallaxBackground/layer_1/background_1".set_visible(1)
		
		$"../ParallaxBackground/layer_2".set_visible(0)
		$"../ParallaxBackground/layer_2/background_2".set_visible(0)
	
	


func _on_level_change_2_copy_area_entered(area: Area2D) -> void:
	print("level 2")
	if current_level == 3:
		
		$"../ParallaxBackground/layer_3".set_visible(0)
		$"../ParallaxBackground/layer_3/background_3".set_visible(0)
		
		$"../ParallaxBackground/layer_2".set_visible(1)
		$"../ParallaxBackground/layer_2/background_2".set_visible(1)



func _on_level_change_3_area_entered(area: Area2D) -> void:
	print ("level 3")
	current_level == 3
	$"../ParallaxBackground/layer_3".set_visible(1)
	$"../ParallaxBackground/layer_3/background_3".set_visible(1)
		
	$"../ParallaxBackground/layer_2".set_visible(0)
	$"../ParallaxBackground/layer_2/background_2".set_visible(0)
	
