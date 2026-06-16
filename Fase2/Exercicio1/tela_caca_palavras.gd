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
	print("O tempo acabou! Game Over!")
	for botao in grid_container.get_children():
		if botao is Button:
			botao.disabled = true

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
			print("Você encontrou: ", palavra_atual)
			
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
			botao.modulate = Color(1, 1, 1) # Reseta para o branco normal
	palavra_atual = ""
	botoes_selecionados.clear()

func ganhou_jogo():
	jogo_acabou = true
	print("Parabéns! Você encontrou todas as palavras!")
	if has_node("Timer"):
		$Timer.stop()
	
	# Sistema de pontos equilibrado
	var tempo_gasto = 420 - tempo_restante
	var pontuacao_caca = int(15 - tempo_gasto)
	if pontuacao_caca < 0: 
		pontuacao_caca = 0
	
	# Puxa o GerenciadorRanking de forma dinâmica
	var pontos_fase1 = 0
	if has_node("/root/GerenciadorRanking"):
		var ger_ranking = get_node("/root/GerenciadorRanking")
		ger_ranking.pontos_exercicio2 = pontuacao_caca
		
		# Balanceia a pontuação antiga se necessário
		if ger_ranking.pontos_exercicio1 > 20:
			ger_ranking.pontos_exercicio1 = int(ger_ranking.pontos_exercicio1 / 10)
		pontos_fase1 = ger_ranking.pontos_exercicio1

	var pontuacao_total = pontos_fase1 + pontuacao_caca
	
	# Chamada 100% segura baseada na árvore de nós raiz
	if has_node("/root/GerenciadorJogo"):
		var no_gerenciador = get_node("/root/GerenciadorJogo")
		if no_gerenciador.has_method("finalizar_jogo"):
			no_gerenciador.finalizar_jogo(pontuacao_total)
	else:
		print("Erro Crítico: O nó /root/GerenciadorJogo não foi mapeado corretamente.")
	
	# Transição de tela
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Fase2/tela_parabens.tscn")
