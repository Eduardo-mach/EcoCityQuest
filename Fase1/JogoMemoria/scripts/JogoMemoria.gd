extends Control

const SCRIPT_CARTA = preload("res://scripts/CartaMemoria.gd")

@onready var logica: Node = $LogicaJogo
@onready var grade_cartas: GridContainer = $GradeCartas
@onready var botao_voltar: TextureButton = $BotaoVoltar
@onready var botao_ajuda: TextureButton = $BotaoAjuda

var textura_verso: Texture2D = preload("res://assets/imagens/verso_carta.png")

# Mapeia o nome do item ecológico para a textura de "frente" da carta
var texturas_frente: Dictionary = {
	"arvore_nativa": preload("res://assets/imagens/carta_arvore_nativa.png"),
	"painel_solar": preload("res://assets/imagens/carta_painel_solar.png"),
	"lixeira_reciclagem": preload("res://assets/imagens/carta_lixeira_reciclagem.png"),
	"bici_compartilhada": preload("res://assets/imagens/carta_bici_compartilhada.png"),
	"carro_eletrico": preload("res://assets/imagens/carta_carro_eletrico.png"),
	"horta_comunitaria": preload("res://assets/imagens/carta_horta_comunitaria.png"),
}

var cartas: Array = [] # Array de CartaMemoria, na mesma ordem do tabuleiro da lógica

func _ready() -> void:
	logica.par_encontrado.connect(_on_par_encontrado)
	logica.par_errado.connect(_on_par_errado)
	logica.jogo_da_memoria_concluido.connect(_on_jogo_concluido)

	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_ajuda.pressed.connect(_on_botao_ajuda_pressed)

	_montar_tabuleiro()

func _montar_tabuleiro() -> void:
	# Limpa cartas antigas, se houver
	for filho in grade_cartas.get_children():
		filho.queue_free()
	cartas.clear()

	var tabuleiro: Array = logica.inicializar_jogo()

	for i in range(tabuleiro.size()):
		var nome_item: String = tabuleiro[i]

		var carta := TextureButton.new()
		carta.set_script(SCRIPT_CARTA)
		carta.custom_minimum_size = Vector2(110, 110)
		carta.ignore_texture_size = true
		carta.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED

		grade_cartas.add_child(carta)

		var frente: Texture2D = texturas_frente.get(nome_item, textura_verso)
		carta.configurar(i, frente, textura_verso)

		cartas.append(carta)

# Chamado pelo script da carta (via /root/JogoMemoria) quando o jogador clica
func on_carta_clicada(carta: Node) -> void:
	carta.mostrar_frente()

	var resultado: Dictionary = await logica.escolher_carta(carta.posicao_index)

	match resultado.get("status", ""):
		"primeira_carta":
			pass # já está virada para frente, nada mais a fazer

		"acertou":
			pass # _on_par_encontrado cuida de bloquear as cartas certas

		"errou":
			_desvirar_cartas_erradas()

		"ignorado":
			pass

func _desvirar_cartas_erradas() -> void:
	for carta in cartas:
		if not carta.bloqueada and carta.virada:
			carta.mostrar_verso()

func _on_par_encontrado(id_carta: String) -> void:
	for carta in cartas:
		if carta.textura_frente == texturas_frente.get(id_carta, null) and carta.virada:
			carta.bloquear()

func _on_par_errado(_id_carta1: int, _id_carta2: int) -> void:
	GerenciadorAudio.tocar("audio_erro_par")

func _on_jogo_concluido() -> void:
	GerenciadorAudio.tocar("audio_parabens_memoria")
	print("Jogo da Memória concluído!")

func _on_botao_voltar_pressed() -> void:
	if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
		get_node("/root/GerenciadorJogo").voltar_exercicio()

func _on_botao_ajuda_pressed() -> void:
	GerenciadorAudio.tocar("audio_ajuda_memoria")
