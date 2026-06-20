extends TextureButton
# Representa uma carta individual no tabuleiro do jogo da memória

@export var posicao_index: int = -1

var virada: bool = false
var bloqueada: bool = false # true quando o par já foi encontrado (não pode mais clicar)

var textura_verso: Texture2D
var textura_frente: Texture2D

func _ready() -> void:
	pressed.connect(_on_pressed)

# Configura a carta com sua posição no tabuleiro e qual imagem ela representa
func configurar(p_posicao_index: int, p_textura_frente: Texture2D, p_textura_verso: Texture2D) -> void:
	posicao_index = p_posicao_index
	textura_frente = p_textura_frente
	textura_verso = p_textura_verso
	mostrar_verso()

func mostrar_verso() -> void:
	virada = false
	texture_normal = textura_verso

func mostrar_frente() -> void:
	virada = true
	texture_normal = textura_frente

func bloquear() -> void:
	bloqueada = true
	disabled = true

func _on_pressed() -> void:
	if bloqueada or virada:
		return

	var jogo = get_node("/root/JogoMemoria")
	jogo.on_carta_clicada(self)
