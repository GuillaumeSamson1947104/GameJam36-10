extends Control

func _on_start_pressed() -> void:
	$MarginContainer/HBoxContainer/CenterContainer/Start.visible = false
	$MarginContainer/HBoxContainer/VBoxContainer/Label.visible = false
	$MarginContainer/MenuAnimationLoop.play("start")

func _on_menu_animation_loop_animation_looped() -> void:
	print($MarginContainer/MenuAnimationLoop.animation )
	if $MarginContainer/MenuAnimationLoop.animation == "start" :
		get_tree().change_scene_to_file("res://Scenes/Level/main.tscn")
