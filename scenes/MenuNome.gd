extends TextureRect

func _ready() -> void:
	# Toca narração "Digite seu nome" assim que a tela abre
	if has_node("/root/GerenciadorAudio"):
		GerenciadorAudio.tocar("digiteSeuNome")

func _on_play_button_pressed() -> void:
	# Lê o nome digitado pelo jogador
	var nome: String = ""
	var campo_nome = get_node_or_null("MarginContainer/VBoxContainer/InputNome")
	if campo_nome and campo_nome is LineEdit:
		nome = campo_nome.text.strip_edges()

	if nome == "":
		nome = "Jogador"

	# Registra o nome e inicia o jogo (também toca o som "Jogar")
	if has_node("/root/GerenciadorJogo"):
		GerenciadorJogo.iniciar_novo_jogo(nome)
	else:
		# Fallback caso o autoload não esteja disponível
		get_tree().change_scene_to_file("res://Fase1/JogoMemoria/Exercicio1/JogoMemoria.tscn")
