extends Node

@onready var menu_about     = $About
@onready var menu_principal = $MenuPrincipal
@onready var menu_exit      = $Exit

var audio_mutado: bool = false

func _ready() -> void:
	# Garante que só o menu principal está visível ao iniciar
	menu_principal.visible = true
	menu_about.visible     = false
	menu_exit.visible      = false

# ── About ──────────────────────────────────────────────────────────────────
func _on_about_button_pressed() -> void:
	menu_principal.visible = false
	menu_exit.visible      = false
	menu_about.visible     = true

func _on_back_button_pressed() -> void:
	menu_principal.visible = true
	menu_about.visible     = false
	menu_exit.visible      = false

# ── Exit ───────────────────────────────────────────────────────────────────
func _on_exit_button_pressed() -> void:
	menu_principal.visible = false
	menu_about.visible     = false
	menu_exit.visible      = true

func _on_nao_pressed() -> void:
	menu_principal.visible = true
	menu_about.visible     = false
	menu_exit.visible      = false

func _on_sim_pressed() -> void:
	get_tree().quit()

# ── Volume / Áudio ─────────────────────────────────────────────────────────
func _on_vol_button_pressed() -> void:
	audio_mutado = not audio_mutado
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), audio_mutado)
	# Feedback visual: opacidade do botão indica estado
	var vol_btn = get_node_or_null("MenuPrincipal/MarginContainer/HBoxContainer/vol_button")
	if vol_btn:
		vol_btn.modulate.a = 0.4 if audio_mutado else 1.0
