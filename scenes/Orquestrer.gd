extends Node

@onready var menu_about = $About
@onready var menu_principal = $MenuPrincipal
@onready var menu_exit = $Exit

func _on_about_button_pressed() -> void:
	menu_principal.visible = false
	menu_exit.visible = false
	menu_about.visible = true


func _on_exit_button_pressed() -> void:
	menu_principal.visible = false
	menu_about.visible = false
	menu_exit.visible = true


func _on_back_button_pressed() -> void:
	menu_principal.visible = true
	menu_about.visible = false
	menu_exit.visible = false


func _on_nao_pressed() -> void:
	menu_principal.visible = true
	menu_about.visible = false
	menu_exit.visible = false



func _on_sim_pressed() -> void:
	get_tree().quit()
