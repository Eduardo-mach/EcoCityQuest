extends Control

const SCRIPT_CARTA = preload("res://scripts/CartaMemoria.gd")

@onready var logica: Node = $LogicaJogo
@onready var grade_cartas: GridContainer = $GradeCartas
@onready var botao_voltar: TextureButton = $BotaoVoltar
@onready var botao_ajuda: TextureButton = $BotaoAjuda

var textura_verso: Texture2D = preload("res://assets/imagens/verso_carta.png")

var texturas_frente: Dictionary = {
	"arvore_nativa": preload("res://assets/imagens/carta_arvore_nativa.png"),
	"painel_solar": preload("res://assets/imagens/carta_painel_solar.png"),
	"lixeira_reciclagem": preload("res://assets/imagens/carta_lixeira_reciclagem.png"),
	"bici_compartilhada": preload("res://assets/imagens/carta_bici_compartilhada.png"),
	"carro_eletrico": preload("res://assets/imagens/carta_carro_eletrico.png"),
	"horta_comunitaria": preload("res://assets/imagens/carta_horta_comunitaria.png"),
}

var cartas: Array = []
var popup_video: Control
var video_player: VideoStreamPlayer

func _ready() -> void:
	logica.par_encontrado.connect(_on_par_encontrado)
	logica.par_errado.connect(_on_par_errado)
	logica.jogo_da_memoria_concluido.connect(_on_jogo_concluido)
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_ajuda.pressed.connect(_on_botao_ajuda_pressed)
	_criar_popup_video()
	_montar_tabuleiro()

func _criar_popup_video() -> void:
	popup_video = Control.new()
	popup_video.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup_video.visible = false
	add_child(popup_video)

	var fundo = ColorRect.new()
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.color = Color(0, 0, 0, 0.7)
	popup_video.add_child(fundo)

	var container = CenterContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup_video.add_child(container)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	container.add_child(vbox)

	video_player = VideoStreamPlayer.new()
	video_player.custom_minimum_size = Vector2(560, 350)
	video_player.stream = load("res://fases/Fase1/Ex1/Tutorial01.ogv")
	video_player.finished.connect(_on_video_finalizado)
	vbox.add_child(video_player)

	var botao_fechar = Button.new()
	botao_fechar.text = "Fechar"
	botao_fechar.custom_minimum_size = Vector2(120, 40)
	botao_fechar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	botao_fechar.pressed.connect(_on_botao_fechar_video_pressed)
	vbox.add_child(botao_fechar)

func _on_botao_ajuda_pressed() -> void:
	popup_video.visible = true
	video_player.play()

func _on_botao_fechar_video_pressed() -> void:
	popup_video.visible = false
	video_player.stop()

func _on_video_finalizado() -> void:
	popup_video.visible = false

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

func on_carta_clicada(carta: Node) -> void:
	carta.mostrar_frente()
	var resultado: Dictionary = await logica.escolher_carta(carta.posicao_index)
	match resultado.get("status", ""):
		"errou":
			_desvirar_cartas_erradas()

func _desvirar_cartas_erradas() -> void:
	for carta in cartas:
		if not carta.bloqueada and carta.virada:
			carta.mostrar_verso()

func _on_par_encontrado(id_carta: String) -> void:
	for carta in cartas:
		if carta.textura_frente == texturas_frente.get(id_carta, null) and carta.virada:
			carta.bloquear()

func _on_par_errado(_id1: int, _id2: int) -> void:
	GerenciadorAudio.tocar("audio_erro_par")

func _on_jogo_concluido() -> void:
	GerenciadorAudio.tocar("audio_parabens_memoria")
	print("Jogo da Memória concluído!")

func _on_botao_voltar_pressed() -> void:
	if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
		get_node("/root/GerenciadorJogo").voltar_exercicio()
