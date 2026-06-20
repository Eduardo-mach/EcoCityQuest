extends TextureRect



func _on_sim_pressed() -> void:
	get_tree().quit()


func _on_nao_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
