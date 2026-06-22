extends Control

@onready var logica: Node = $LogicaExercicio
@onready var item_placa: Control = $ItemPlacaSolar
@onready var item_entulho: Control = $ItemEntulho
@onready var drop_telhado: Control = $DropTelhado
@onready var botao_voltar: TextureButton = $BotaoVoltar
@onready var botao_ajuda: TextureButton = $BotaoAjuda
@onready var timer_exercicio: Timer = $TimerExercicio
@onready var timer_label: Label = $TimerExercicio/LabelTimer

# Aqui acessamos o filho VideoStreamPlayer dentro do Control "video_player"
@onready var video_player: VideoStreamPlayer = $video_player/VideoStreamPlayer

var tempo_restante: int = 180  # 3 minutos em segundos

func _ready() -> void:
	if logica.has_signal("objetivo_concluido"):
		logica.connect("objetivo_concluido", Callable(self, "_on_objetivo_concluido"))
	if logica.has_signal("exercicio_finalizado"):
		logica.connect("exercicio_finalizado", Callable(self, "_on_exercicio_finalizado"))

	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_ajuda.pressed.connect(_on_botao_ajuda_pressed)

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
		logica.emit_signal("exercicio_finalizado")

func formatar_tempo(segundos: int) -> String:
	var minutos = int(segundos / 60)
	var seg = int(segundos % 60)
	return str(minutos).pad_zeros(2) + ":" + str(seg).pad_zeros(2)

# Botão de ajuda abre vídeo
func _on_botao_ajuda_pressed() -> void:
	video_player.stream = load("res://Fotos/Tutorial02.ogv")
	video_player.play()
	video_player.visible = true

# Botão voltar
func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

# Lógica de objetivo concluído
func _on_objetivo_concluido(tipo: String) -> void:
	if tipo == "telhado":
		item_entulho.visible = false

# Lógica de exercício finalizado
func _on_exercicio_finalizado() -> void:
	print("Exercício Fase 1 - Exercício 2 concluído!")
	var gerenciador = get_node("/root/GerenciadorJogo")
	if gerenciador:
		gerenciador.avancar_exercicio()
	else:
		push_error("GerenciadorJogo não encontrado.")

# Processamento de arrastar item
func processar_item_arrastado(nome_objeto: String, nome_alvo: String) -> Dictionary:
	if nome_objeto == "placa_solar" and nome_alvo == "telhado":
		return {"sucesso": true}
	return {"sucesso": false}

func _on_video_stream_player_finished() -> void:
	$video_player/VideoStreamPlayer.hide()
 
