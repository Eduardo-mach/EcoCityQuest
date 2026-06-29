extends Control

# Puxa os nós de texto direto da raiz conforme a sua árvore real
@onready var titulo = $Titulo
@onready var descricao = $Descricao
@onready var cronometro_visual = $Timer/TextoDoTempo
@onready var timer_interno = $Timer

# Puxa o nó da imagem da rua para podermos alterá-la
@onready var imagem_rua = $ImagemRua

# Variáveis do Jogo
var tempo_restante = 420
var jogo_finalizado = false

# Variáveis para controlar se o jogador já usou cada item correto
var usou_trator = false
var usou_arvore = false

func _ready():
	# 1. Configura o visual do tempo assim que a tela abre
	atualizar_texto_cronometro()

	# 2. Conecta o sinal do seu Timer físico da árvore de nós
	timer_interno.timeout.connect(_on_timer_timeout)
	timer_interno.wait_time = 1.0
	timer_interno.one_shot = false
	timer_interno.start()

	# 3. Cliques de segurança (Caso o jogador decida clicar em vez de arrastar)
	$"Botao Entulho".gui_input.connect(func(event): _on_opcao_clicada(event, "Botao Entulho"))
	$Botao_Arvore.gui_input.connect(func(event): _on_opcao_clicada(event, "Botao_Arvore"))
	$Botao_Rolo.gui_input.connect(func(event): _on_opcao_clicada(event, "Botao_Rolo"))

# Função que roda a cada 1 segundo
func _on_timer_timeout():
	if tempo_restante > 0:
		tempo_restante -= 1
		atualizar_texto_cronometro()
	else:
		timer_interno.stop()
		game_over()

# Converte os segundos para o formato bonitinho de MM:SS (Ex: 07:00)
func atualizar_texto_cronometro():
	var minutos = tempo_restante / 60
	var segundos = tempo_restante % 60
	cronometro_visual.text = "%02d:%02d" % [minutos, segundos]

# Essa função central processa a escolha (seja por clique ou por arrastar e soltar)
func processar_escolha(nome_objeto: String):
	if jogo_finalizado: return

	match nome_objeto:
		"Botao Entulho":
			titulo.text = "QUASE LÁ"
			descricao.text = "O entulho é composto por restos de obras e sujeira. Vamos tentar novamente?"
			titulo.modulate = Color(1, 0.4, 0.4)
			descricao.modulate = Color(1, 0.4, 0.4)

		"Botao_Rolo":
			if not usou_trator:
				usou_trator = true
				$Botao_Rolo.modulate = Color(0.5, 0.5, 0.5)
				imagem_rua.texture = load("res://Fotos/rua_lisa.png")
				verificar_progresso_jogo("O tratorzinho aplainou o asfalto e tapou todos os buracos da rua!")

		"Botao_Arvore":
			if not usou_arvore:
				usou_arvore = true
				$Botao_Arvore.modulate = Color(0.5, 0.5, 0.5)
				verificar_progresso_jogo("Você plantou árvores ao longo da via para trazer mais sustentabilidade!")

func verificar_progresso_jogo(mensagem_atual: String):
	if usou_trator and usou_arvore:
		jogo_finalizado = true
		timer_interno.stop()
		titulo.text = "PARABÉNS!"
		descricao.text = "Você usou o trator para arrumar o asfalto e plantou árvores para criar uma linda rua verde e sustentável!"
		titulo.modulate = Color(0.3, 1, 0.3)
		descricao.modulate = Color(0.3, 1, 0.3)

		# CALCULA A PONTUAÇÃO (mais tempo restante = mais pontos, max 8400)
		var pontuacao_rua = int(tempo_restante * 20)
		pontuacao_rua = clamp(pontuacao_rua, 0, 8400)

		# SALVA NO GERENCIADORRANKING
		if has_node("/root/GerenciadorRanking"):
			GerenciadorRanking.pontos_rua = pontuacao_rua
			print("[ConserteARua] Pontuação salva: ", pontuacao_rua)

		# Salva pontuação total no ranking histórico (último jogo da sequência)
		if has_node("/root/GerenciadorRanking") and has_node("/root/GerenciadorJogo"):
			var total = GerenciadorRanking.get_pontuacao_total()
			GerenciadorJogo.finalizar_jogo(total)
			print("[ConserteARua] Pontuação total salva no ranking: ", total)

		# Espera 2 segundos e avança para ranking_rua via GerenciadorJogo
		await get_tree().create_timer(2.0).timeout
		if has_node("/root/GerenciadorJogo"):
			GerenciadorJogo.avancar_exercicio()

	else:
		titulo.text = "MUITO BEM..."
		descricao.text = mensagem_atual + " A rua ainda precisa de mais uma melhoria. O que mais falta fazer?"
		titulo.modulate = Color(0.3, 0.7, 1)
		descricao.modulate = Color(0.3, 0.7, 1)

# Identifica se houve clique de mouse tradicional nas imagens
func _on_opcao_clicada(event, nome_objeto: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		processar_escolha(nome_objeto)

# Lógica caso o tempo esgote
func game_over():
	jogo_finalizado = true
	titulo.text = "FIM DE TEMPO!"
	descricao.text = "O cronômetro zerou! Vamos tentar de novo?."
	titulo.modulate = Color(1, 0.3, 0.3)
	descricao.modulate = Color(1, 0.3, 0.3)

	# Mesmo com game over, avança para o ranking (com 0 pontos)
	if has_node("/root/GerenciadorRanking"):
		GerenciadorRanking.pontos_rua = 0

	await get_tree().create_timer(2.0).timeout
	if has_node("/root/GerenciadorJogo"):
		GerenciadorJogo.avancar_exercicio()
