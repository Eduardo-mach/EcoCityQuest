extends Control

@onready var grid_container = $GridContainer_Matriz
@onready var label_cronometro = $Label_Cronometro

# Variáveis do Caça-Palavras
const MATRIZ_LETRAS = [
	"E","O","L","I","C","A","B","R",
	"P","A","T","R","E","U","S","O",
	"S","O","L","A","R","M","V","E",
	"Q","W","I","E","C","O","L","A",
	"X","Z","C","A","B","T","E","O",
	"U","F","H","G","K","L","P","X"
]
var palavras_para_achar = ["EOLICA", "REUSO", "SOLAR", "ECO"]
var palavras_descobertas = []
var palavra_atual = ""
var botoes_selecionados = []

# VARIÁVEIS DO CRONÔMETRO
var tempo_restante = 420
var jogo_acabou = false

func _ready():
	criar_tabuleiro()
	atualizar_texto_cronometro()

	if has_node("Timer"):
		$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if jogo_acabou:
		return
	if tempo_restante > 0:
		tempo_restante -= 1
		atualizar_texto_cronometro()
	else:
		game_over()

func atualizar_texto_cronometro():
	var minutos = tempo_restante / 60
	var segundos = tempo_restante % 60
	label_cronometro.text = "%02d:%02d" % [minutos, segundos]

func game_over():
	jogo_acabou = true
	print("[CaçaPalavras] O tempo acabou! Game Over!")
	for botao in grid_container.get_children():
		if botao is Button:
			botao.disabled = true

	# Salva 0 pontos e avança
	if has_node("/root/GerenciadorRanking"):
		GerenciadorRanking.pontos_caca_palavras = 0

	await get_tree().create_timer(1.5).timeout
	if has_node("/root/GerenciadorJogo"):
		GerenciadorJogo.avancar_exercicio()

func criar_tabuleiro():
	for child in grid_container.get_children():
		child.queue_free()
	for letra in MATRIZ_LETRAS:
		var botao = Button.new()
		botao.text = letra
		botao.custom_minimum_size = Vector2(50, 50)
		botao.add_theme_font_size_override("font_size", 24)

		# Estilo Visual: Fundo Branco e Letra Preta
		botao.add_theme_color_override("font_color", Color(0, 0, 0))
		botao.add_theme_color_override("font_hover_color", Color(0, 0, 0))
		botao.add_theme_color_override("font_pressed_color", Color(0, 0, 0))
		botao.add_theme_color_override("font_disabled_color", Color(1, 1, 1))

		var estilo_branco = StyleBoxFlat.new()
		estilo_branco.bg_color = Color(1, 1, 1)
		estilo_branco.set_corner_radius_all(4)
		estilo_branco.border_color = Color(0, 0, 0)
		estilo_branco.set_border_width_all(2)
		botao.add_theme_stylebox_override("normal", estilo_branco)
		botao.add_theme_stylebox_override("hover", estilo_branco)
		botao.add_theme_stylebox_override("pressed", estilo_branco)

		botao.pressed.connect(_on_letra_pressionada.bind(botao))
		grid_container.add_child(botao)

func _on_letra_pressionada(botao_clicado: Button):
	if jogo_acabou or botao_clicado in botoes_selecionados:
		return

	palavra_atual += botao_clicado.text
	botoes_selecionados.append(botao_clicado)
	botao_clicado.modulate = Color(1, 1, 0) # Amarelo ao selecionar

	verificar_palavra()

func verificar_palavra():
	var prefixo_valido = false
	for p in palavras_para_achar:
		if p.begins_with(palavra_atual):
			prefixo_valido = true
			break

	if palavra_atual in palavras_para_achar:
		if not palavra_atual in palavras_descobertas:
			palavras_descobertas.append(palavra_atual)
			print("[CaçaPalavras] Você encontrou: ", palavra_atual)

			for botao in botoes_selecionados:
				botao.modulate = Color(0, 1, 0) # Verde definitivo
				botao.disabled = true

			var nome_no_lista = "Label_" + palavra_atual
			if has_node(nome_no_lista):
				get_node(nome_no_lista).modulate = Color(0.4, 0.4, 0.4)

			palavra_atual = ""
			botoes_selecionados.clear()

			if palavras_descobertas.size() == palavras_para_achar.size():
				ganhou_jogo()

	elif not prefixo_valido:
		limpar_selecao_errada()

func limpar_selecao_errada():
	for botao in botoes_selecionados:
		if not botao.disabled:
			botao.modulate = Color(1, 1, 1) # Reseta para branco normal
	palavra_atual = ""
	botoes_selecionados.clear()

func ganhou_jogo():
	jogo_acabou = true
	print("[CaçaPalavras] Parabéns! Todas as palavras encontradas!")
	if has_node("Timer"):
		$Timer.stop()

	# Sistema de pontos: mais tempo restante = mais pontos (max 840)
	var pontuacao_caca = int(tempo_restante * 2)
	pontuacao_caca = clamp(pontuacao_caca, 0, 840)

	# Salva pontuação do Caça-Palavras
	if has_node("/root/GerenciadorRanking"):
		GerenciadorRanking.pontos_caca_palavras = pontuacao_caca
		print("[CaçaPalavras] Pontuação salva: ", pontuacao_caca)

	# Avança para ranking_cacapalavras via GerenciadorJogo
	await get_tree().create_timer(1.5).timeout
	if has_node("/root/GerenciadorJogo"):
		GerenciadorJogo.avancar_exercicio()
