extends Button

func _on_pressed():
	get_node("VideoStreamPlayer").visible = true
	get_node("VideoStreamPlayer").play()
	GerenciadorAudio.tocar("ajuda")

func _on_video_stream_player_finished() -> void:
	get_node("VideoStreamPlayer").visible = false
