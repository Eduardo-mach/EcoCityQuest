extends Control

@onready var logica: Node = $LogicaExercicio
@onready var item_placa: Control = $ItemPlacaSolar
@onready var item_entulho: Control = $ItemEntulho
@onready var drop_telhado: Control = $DropTelhado
@onready var botao_voltar: TextureButton = $BotaoVoltar
@onready var botao_ajuda: TextureButton = $BotaoAjuda

var popup_video: Control
var video_player: VideoStreamPlayer

func _ready() -> void:
	logica.objetivo_concluido.connect(_on_objetivo_concluido)
	logica.exercicio_finalizado.connect(_on_exercicio_finalizado)
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_ajuda.pressed.connect(_on_botao_video_pressed)
	_criar_popup_video()
	logica.inicializar_exercicio()

func _criar_popup_video() -> void:
	popup_video = Control.new()
	popup_video.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup_video.visible = false
	add_child(popup_video)

	var fundo = ColorRect.new()
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.color = Color(0, 0, 0, 0.7)
	popup_video.add_child(fundo)

	var tamanho_video = Vector2(560, 350)
	var tela = get_viewport_rect().size
	var pos_centralizada = (tela - tamanho_video) / 2

	video_player = VideoStreamPlayer.new()
	video_player.expand = true
	video_player.size = tamanho_video
	video_player.position = pos_centralizada
	video_player.stream = load("res://Fotos e Videos/Tutorial02.ogv")
	video_player.finished.connect(_on_video_finalizado)
	popup_video.add_child(video_player)

	var tamanho_fechar = Vector2(120, 40)
	var botao_fechar = Button.new()
	botao_fechar.text = "Fechar"
	botao_fechar.size = tamanho_fechar
	botao_fechar.position = Vector2(
		(tela.x - tamanho_fechar.x) / 2,
		pos_centralizada.y + tamanho_video.y + 20
	)
	popup_video.add_child(botao_fechar)
	botao_fechar.pressed.connect(_on_botao_fechar_video_pressed)

func _on_botao_video_pressed() -> void:
	popup_video.visible = true
	video_player.play()

func _on_botao_fechar_video_pressed() -> void:
	popup_video.visible = false
	video_player.stop()

func _on_video_finalizado() -> void:
	popup_video.visible = false

func _on_objetivo_concluido(tipo: String) -> void:
	if tipo == "telhado":
		item_entulho.visible = false
		# Exemplo: dar pontos quando o objetivo é concluído
		get_node("/root/GerenciadorJogo").adicionar_pontos(10)

func _on_exercicio_finalizado() -> void:
	print("Exercício Fase 1 - Exercício 2 concluído!")
	# Pontua ao finalizar
	get_node("/root/GerenciadorJogo").adicionar_pontos(20)
	get_node("/root/GerenciadorJogo").avancar_exercicio()

func _on_botao_voltar_pressed() -> void:
	get_node("/root/GerenciadorJogo").voltar_exercicio()

func processar_item_arrastado(nome_objeto: String, nome_alvo: String) -> Dictionary:
	if nome_objeto == "placa_solar" and nome_alvo == "telhado":
		return {"sucesso": true}
	return {"sucesso": false}
