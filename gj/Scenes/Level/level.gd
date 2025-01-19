extends Node2D
var current_level = 1


func _on_level_change_1_area_entered(area: Area2D) -> void:
	print("level 2")
	current_level == 2
	$"../ParallaxBackground/layer_1".set_visible(0)
	$"../ParallaxBackground/layer_1/background_1".set_visible(0)
		
	$"../ParallaxBackground/layer_2".set_visible(1)
	$"../ParallaxBackground/layer_2/background_2".set_visible(1)
		
	


func _on_level_change_2_area_entered(area: Area2D) -> void:
		print("level 1")
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
	
func _on_end_area_entered(area: Area2D) -> void:
	$Node2D/Camera2D/CanvasLayer/fadeToWhite.play("fade_to_white")
	$Node2D.velocity.y = 0
	$Node2D.velocity.x *= 0.05
	$Node2D.GRAVITY = 10
	$Node2D.GRAVITY_FLOAT = 10

func _on_fade_to_white_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/End/EndScene.tscn")
