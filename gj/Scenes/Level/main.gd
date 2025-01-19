extends Node2D

func _on_music_player_finished() -> void:
	$MusicPlayer.play()
