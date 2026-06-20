extends TextureRect

func _on_iniciar_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_nome.tscn")

func _on_about_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_about.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_exit.tscn")
