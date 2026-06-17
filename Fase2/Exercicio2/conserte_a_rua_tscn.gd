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
			titulo.modulate = Color(1, 0.4, 0.4) # Vermelho/Laranja firme
			descricao.modulate = Color(1, 0.4, 0.4)
			
		"Botao_Rolo":
			if not usou_trator:
				usou_trator = true
				$Botao_Rolo.modulate = Color(0.5, 0.5, 0.5) # Escurece o botão usado
				
				# Altera a imagem da rua na hora (Substitua pelo caminho real da sua foto)
				imagem_rua.texture = load("res://Fotos/rua_lisa.png")
				
				verificar_progresso_jogo("O tratorzinho aplainou o asfalto e tapou todos os buracos da rua!")
			
		"Botao_Arvore":
			if not usou_arvore:
				usou_arvore = true
				$Botao_Arvore.modulate = Color(0.5, 0.5, 0.5)
				verificar_progresso_jogo("Você plantou árvores ao longo da via para trazer mais sustentabilidade!")

# --- FUNÇÃO SUBSTITUÍDA E ATUALIZADA AQUI ---
func verificar_progresso_jogo(mensagem_atual: String):
	if usou_trator and usou_arvore:
		jogo_finalizado = true
		timer_interno.stop()
		titulo.text = "PARABÉNS!"
		descricao.text = "Você usou o trator para arrumar o asfalto e plantou árvores para criar uma linda rua verde e sustentável!"
		titulo.modulate = Color(0.3, 1, 0.3)
		descricao.modulate = Color(0.3, 1, 0.3)
		
		# CALCULA A PONTUAÇÃO
		var tempo_gasto = 420 - tempo_restante
		var erros = 0 
		var pontuacao_rua = int(10000 - (erros * 100) - tempo_gasto)
		if pontuacao_rua < 0: pontuacao_rua = 0
		
		# SALVA DIRETO NO SEU NODE DE RANKING GLOBAL
		# Mudamos o caminho aqui para conversar com o nó que deu na imagem!
		var ranking_global = get_node("/root/GerenciadorRanking")
		ranking_global.pontos_exercicio1 = pontuacao_rua
		
		# Espera 3 segundos e avança para a tela de parabéns
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Fase2/tela_pontuacao1.tscn")
		
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
