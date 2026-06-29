extends Control

func _ready() -> void:
	# Conecta o sinal de clique ao método
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	# Troca para a cena do menu principal
	get_tree().change_scene_to_file("res://scenes/orquestrer.tscn")
