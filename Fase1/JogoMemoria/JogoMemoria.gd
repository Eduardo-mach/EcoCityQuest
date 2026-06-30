extends Control

const SCRIPT_CARTA = preload("res://Fase1/JogoMemoria/CartaMemoria.gd")

@onready var logica: Node = $LogicaJogo
@onready var grade_cartas: GridContainer = $GradeCartas
@onready var botao_voltar: TextureButton = $BotaoVoltar

@onready var timer: Timer = get_node_or_null("TimerExercicio") as Timer
@onready var label_timer: Label = get_node_or_null("LabelTimer") as Label

var textura_verso: Texture2D = preload("res://assets/verso_carta.png")

var texturas_frente: Dictionary = {
	"arvore_nativa":      preload("res://assets/carta_arvore_nativa.png"),
	"painel_solar":       preload("res://assets/carta_painel_solar.png"),
	"lixeira_reciclagem": preload("res://assets/carta_lixeira_reciclagem.png"),
	"bici_compartilhada": preload("res://assets/carta_bici_compartilhada.png"),
	"carro_eletrico":     preload("res://assets/carta_carro_eletrico.png"),
	"horta_comunitaria":  preload("res://assets/carta_horta_comunitaria.png"),
}

var cartas: Array = []
var popup_video: Control
var video_player: VideoStreamPlayer
var tempo_restante: int = 180  # 3 minutos

# ─── CONTROLE DE CLIQUE ───────────────────────────────────────────────────────
# Enquanto aguardando_resultado = true, novos cliques são ignorados.
# Isso garante que o jogador veja as duas cartas antes de desvirar.
var aguardando_resultado: bool = false

func _ready() -> void:
	if logica and logica.has_signal("par_encontrado"):
		logica.connect("par_encontrado", Callable(self, "_on_par_encontrado"))

	botao_voltar.pressed.connect(_on_botao_voltar_pressed)

	_montar_tabuleiro()
	atualizar_label()

	if timer:
		timer.wait_time = 1.0
		timer.one_shot = false
		timer.timeout.connect(Callable(self, "_on_timer_timeout"))
		timer.start()
	else:
		push_warning("TimerExercicio não encontrado na cena.")

# ─── CRONÔMETRO ───────────────────────────────────────────────────────────────
func _on_timer_timeout() -> void:
	tempo_restante -= 1
	atualizar_label()
	if tempo_restante <= 0:
		if timer:
			timer.stop()
		terminar()

func atualizar_label() -> void:
	var minutos = int(tempo_restante / 60)
	var segundos = int(tempo_restante % 60)
	var texto = "%02d:%02d" % [minutos, segundos]

	if not label_timer:
		var found = find_child("LabelTimer", true, false)
		if found and found is Label:
			label_timer = found as Label
		else:
			label_timer = get_node_or_null("CronometroVisual/LabelTimer") as Label

	if not label_timer:
		print("Timer:", texto)
		return
	label_timer.text = texto


# ─── TABULEIRO ────────────────────────────────────────────────────────────────
func _montar_tabuleiro() -> void:
	for filho in grade_cartas.get_children():
		filho.queue_free()
	cartas.clear()

	var tabuleiro: Array = logica.inicializar_jogo()
	for i in range(tabuleiro.size()):
		var carta := TextureButton.new()
		carta.set_script(SCRIPT_CARTA)
		carta.custom_minimum_size = Vector2(110, 110)
		carta.ignore_texture_size = true
		carta.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		grade_cartas.add_child(carta)
		var frente: Texture2D = texturas_frente.get(tabuleiro[i], textura_verso)
		carta.configurar(i, frente, textura_verso)
		cartas.append(carta)

# ─── LÓGICA DE CLIQUE NAS CARTAS ─────────────────────────────────────────────
# Chamado por CartaMemoria._on_pressed()
func on_carta_clicada(carta: Node) -> void:
	# Bloqueia cliques enquanto estamos avaliando um par (aguardando desvirar)
	if aguardando_resultado:
		return
	# Ignora cartas já bloqueadas ou já viradas (segurança extra)
	if carta.bloqueada or carta.virada:
		return

	# Vira a carta clicada imediatamente
	carta.mostrar_frente()

	# Consulta a lógica do jogo
	var resultado: Dictionary = logica.escolher_carta(carta.posicao_index)

	match resultado.get("status", ""):
		"acertou":
			# Par encontrado: _on_par_encontrado() já foi emitido pela lógica
			# As cartas ficam viradas – nenhuma ação extra necessária aqui
			pass

		"errou":
			# Duas cartas viradas e NÃO formam par.
			# Bloqueia novos cliques, aguarda 1,2s para o jogador ver, depois desvira.
			aguardando_resultado = true
			await get_tree().create_timer(1.2).timeout
			_desvirar_cartas_nao_pareadas()
			aguardando_resultado = false

		"continuar":
			# Primeira carta virada – apenas espera o próximo clique
			pass

# Desvira SOMENTE as cartas que estão viradas mas não bloqueadas (par não encontrado)
func _desvirar_cartas_nao_pareadas() -> void:
	for carta in cartas:
		if not carta.bloqueada and carta.virada:
			carta.mostrar_verso()

# ─── PAR ENCONTRADO ───────────────────────────────────────────────────────────
func _on_par_encontrado(id_carta: String) -> void:
	# Bloqueia as duas cartas do par recém-encontrado
	for carta in cartas:
		if carta.textura_frente == texturas_frente.get(id_carta, null) and carta.virada:
			carta.bloquear()

	# Verifica se o jogo terminou (todas as cartas bloqueadas)
	var terminou = true
	for carta in cartas:
		if not carta.bloqueada:
			terminou = false
			break

	if terminou:
		print("[JogoMemoria] Todos os pares encontrados!")
		_concluir_jogo()

# ─── TEMPO ESGOTADO ───────────────────────────────────────────────────────────
func terminar() -> void:
	print("[JogoMemoria] Tempo esgotado!")
	# Impede novos cliques
	aguardando_resultado = true
	_concluir_jogo()

# ─── CONCLUSÃO ────────────────────────────────────────────────────────────────
func _concluir_jogo() -> void:
	if timer:
		timer.stop()

	# Pontuação: cada segundo restante vale 5 pontos (máximo 900)
	var pontuacao = clamp(int(tempo_restante * 5), 0, 900)

	if has_node("/root/GerenciadorRanking"):
		GerenciadorRanking.pontos_memoria = pontuacao
		print("[JogoMemoria] Pontuação salva: ", pontuacao)

	if has_node("/root/GerenciadorJogo"):
		GerenciadorJogo.avancar_exercicio()

# ─── BOTÃO VOLTAR ────────────────────────────────────────────────────────────
func _on_botao_voltar_pressed() -> void:
	if has_node("/root/GerenciadorAudio"):
		GerenciadorAudio.tocar("voltar")
	get_tree().change_scene_to_file("res://scenes/orquestrer.tscn")
