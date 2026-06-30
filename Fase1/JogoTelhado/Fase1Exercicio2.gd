extends Control

@onready var logica: Node = $LogicaExercicio
@onready var item_placa: Control = $ItemPlacaSolar
@onready var item_entulho: Control = $ItemEntulho
@onready var drop_telhado: Control = $DropTelhado
@onready var botao_voltar: TextureButton = $BotaoVoltar
#@onready var botao_ajuda: TextureButton = $BotaoAjuda
@onready var timer_exercicio: Timer = $TimerExercicio
@onready var timer_label: Label = $TimerExercicio/LabelTimer

var tempo_restante: int = 180  # 3 minutos em segundos

var popup_video: Control
var video_player: VideoStreamPlayer

func _ready() -> void:
	if logica.has_signal("objetivo_concluido"):
		logica.connect("objetivo_concluido", Callable(self, "_on_objetivo_concluido"))
	if logica.has_signal("exercicio_finalizado"):
		logica.connect("exercicio_finalizado", Callable(self, "_on_exercicio_finalizado"))

	botao_voltar.pressed.connect(_on_botao_voltar_pressed)

	logica.inicializar_exercicio()
	# Configura Timer para disparar a cada 1 segundo
	timer_exercicio.wait_time = 1.0
	timer_exercicio.one_shot = false
	timer_exercicio.timeout.connect(_atualizar_cronometro)
	timer_exercicio.start()

	# Mostra tempo inicial
	timer_label.text = formatar_tempo(tempo_restante)

# Atualiza cronômetro na tela
func _atualizar_cronometro() -> void:
	tempo_restante -= 1
	if tempo_restante > 0:
		timer_label.text = formatar_tempo(tempo_restante)
	else:
		timer_exercicio.stop()
		timer_label.text = "Tempo esgotado!"
		# Força conclusão com 0 pontos de tempo
		_finalizar(false)

func formatar_tempo(segundos: int) -> String:
	var minutos = int(segundos / 60)
	var seg = int(segundos % 60)
	return str(minutos).pad_zeros(2) + ":" + str(seg).pad_zeros(2)

# Botão voltar
func _on_botao_voltar_pressed() -> void:
	if has_node("/root/GerenciadorAudio"):
		GerenciadorAudio.tocar("voltar")
	get_tree().change_scene_to_file("res://scenes/orquestrer.tscn")

# Lógica de objetivo concluído (o telhado foi completado)
func _on_objetivo_concluido(tipo: String) -> void:
	if tipo == "telhado":
		item_entulho.visible = false

# Lógica de exercício finalizado (emitido pela LogicaFase1Exercicio2)
func _on_exercicio_finalizado() -> void:
	_finalizar(logica.telhado_concluido)

func _finalizar(sucesso: bool) -> void:
	timer_exercicio.stop()

	# Calcula pontuação: mais tempo restante = mais pontos (max 900)
	var pontuacao = int(tempo_restante * 5) if sucesso else 0
	pontuacao = clamp(pontuacao, 0, 900)

	# Salva no GerenciadorRanking
	if has_node("/root/GerenciadorRanking"):
		GerenciadorRanking.pontos_telhado = pontuacao
		print("[JogoTelhado] Pontuação salva: ", pontuacao)

	# Avança para ranking_telhado via GerenciadorJogo
	if has_node("/root/GerenciadorJogo"):
		GerenciadorJogo.avancar_exercicio()
	else:
		push_error("[JogoTelhado] GerenciadorJogo não encontrado.")

# Processamento de arrastar item
func processar_item_arrastado(nome_objeto: String, nome_alvo: String) -> Dictionary:
	if nome_objeto == "placa_solar" and nome_alvo == "telhado":
		return {"sucesso": true}
	return {"sucesso": false}
