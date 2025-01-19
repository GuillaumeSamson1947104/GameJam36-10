extends Node2D

func _on_music_player_finished() -> void:
	$MusicPlayer.play()
	
func placeholderend() :
	$Level/Node2D/Camera2D/CanvasLayer/fadeToWhite.play("fade_to_white")

func _on_fade_to_white_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/End/EndScene.tscn")
