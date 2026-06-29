extends Control

# tela_ranking.gd – agora esta tela exibe o Ranking Geral final da Fase 2.
# Ela é carregada pelo fluxo antigo via tela_parabens.gd.
# Com o novo fluxo via GerenciadorJogo, ela não é mais usada diretamente,
# mas mantemos compatibilidade para o caso de ser chamada externamente.

func _ready():
	# Popula as barras de ranking com os dados do GerenciadorJogo
	if not has_node("/root/GerenciadorJogo"):
		return

	var ranking = get_node("/root/GerenciadorJogo").ranking

	var barras = [
		get_node_or_null("Barra_1Lugar/Texto_Placar"),
		get_node_or_null("Barra_2Lugar/Texto_Placar"),
		get_node_or_null("Barra_3Lugar/Texto_Placar"),
	]

	var medalhas_prefix = ["🥇  ", "🥈  ", "🥉  "]

	for i in range(min(3, ranking.size())):
		if barras[i]:
			var entrada = ranking[i]
			barras[i].text = medalhas_prefix[i] + str(entrada.get("nome", "?")) + "   " + str(entrada.get("pontuacao", 0)) + " pts"
			barras[i].add_theme_font_size_override("font_size", 22)

	# Conecta botão voltar se existir
	var botao_voltar = get_node_or_null("Botao_Voltar")
	if botao_voltar:
		botao_voltar.visible = true
		botao_voltar.pressed.connect(_on_voltar_pressed)

func _on_voltar_pressed():
	if has_node("/root/GerenciadorAudio"):
		GerenciadorAudio.tocar("voltar")
	get_tree().change_scene_to_file("res://scenes/orquestrer.tscn")
