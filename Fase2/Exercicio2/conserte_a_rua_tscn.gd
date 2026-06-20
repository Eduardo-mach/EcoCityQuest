extends Control

# Puxa os nós de texto direto da raiz conforme a sua árvore real
@onready var titulo = $Titulo
@onready var descricao = $Descricao
@onready var cronometro_visual = $Timer/TextoDoTempo
@onready var timer_interno = $Timer

# Puxa o nó da imagem da rua para podermos alterá-la
@onready var imagem_rua = $ImagemRua

# Botão e vídeo do tutorial
@onready var botao_tutorial = $Botao_Tutorial
@onready var video_player = $VideoPlayer_Tutorial

# Variáveis do Jogo
var tempo_restante = 420
var jogo_finalizado = false

# Variáveis para controlar se o jogador já usou cada item correto
var usou_trator = false
var usou_arvore = false

func _ready():
	# Configura o cronômetro
	atualizar_texto_cronometro()
	timer_interno.timeout.connect(_on_timer_timeout)
	timer_interno.wait_time = 1.0
	timer_interno.one_shot = false
	timer_interno.start()

	# Conecta os cliques de segurança
	$"Botao Entulho".gui_input.connect(func(event): _on_opcao_clicada(event, "Botao Entulho"))
	$Botao_Arvore.gui_input.connect(func(event): _on_opcao_clicada(event, "Botao_Arvore"))
	$Botao_Rolo.gui_input.connect(func(event): _on_opcao_clicada(event, "Botao_Rolo"))

	# Configura o vídeo tutorial
	video_player.stream = load("res://Fase2/Exercicio2/Tutorial04.ogv") # ajuste o caminho conforme seu projeto
	video_player.visible = false
	botao_tutorial.pressed.connect(_on_botao_tutorial_pressed)

# --- Tutorial ---
func _on_botao_tutorial_pressed():
	video_player.visible = true
	video_player.play()

func _on_video_player_tutorial_finished() -> void:
	video_player.stop()
	video_player.visible = false

# --- Cronômetro ---
func _on_timer_timeout():
	if tempo_restante > 0:
		tempo_restante -= 1
		atualizar_texto_cronometro()
	else:
		timer_interno.stop()
		game_over()

func atualizar_texto_cronometro():
	var minutos = tempo_restante / 60
	var segundos = tempo_restante % 60
	cronometro_visual.text = "%02d:%02d" % [minutos, segundos]

# --- Escolhas ---
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
		
		var tempo_gasto = 420 - tempo_restante
		var erros = 0 
		var pontuacao_rua = int(10000 - (erros * 100) - tempo_gasto)
		if pontuacao_rua < 0: pontuacao_rua = 0
		
		if has_node("/root/GerenciadorRanking"):
			var ranking_global = get_node("/root/GerenciadorRanking")
			ranking_global.pontos_exercicio1 = pontuacao_rua
		
		await get_tree().create_timer(3.0).timeout
		if has_node("/root/GerenciadorJogo"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()
	else:
		titulo.text = "MUITO BEM..."
		descricao.text = mensagem_atual + " A rua ainda precisa de mais uma melhoria. O que mais falta fazer?"
		titulo.modulate = Color(0.3, 0.7, 1)
		descricao.modulate = Color(0.3, 0.7, 1)

func _on_opcao_clicada(event, nome_objeto: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		processar_escolha(nome_objeto)

func game_over():
	jogo_finalizado = true
	titulo.text = "FIM DE TEMPO!"
	descricao.text = "O cronômetro zerou! Vamos tentar de novo?."
	titulo.modulate = Color(1, 0.3, 0.3)
	descricao.modulate = Color(1, 0.3, 0.3)
