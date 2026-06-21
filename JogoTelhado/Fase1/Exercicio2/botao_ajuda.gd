extends Button

func _on_pressed():
	get_node("VideoStreamPlayer").visible = true
	get_node("VideoStreamPlayer").play()


func _on_video_stream_player_finished() -> void:
	get_node("VideoStreamPlayer").visible = false
