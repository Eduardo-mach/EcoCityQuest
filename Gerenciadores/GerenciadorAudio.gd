extends Node
# Gerenciador de Áudio – dois players para evitar que SFX corte narrações

var sons: Dictionary = {
	"ajuda":          preload("res://assets/Audios/Ajuda.mp3"),
	"avancar":        preload("res://assets/Audios/Avançar.mp3"),
	"digiteSeuNome":  preload("res://assets/Audios/Digite-seu-nome.mp3"),
	"ecoCityQuest":   preload("res://assets/Audios/EcoCityQuest.mp3"),
	"fase1_ex1":      preload("res://assets/Audios/Fase1Ex1.mp3"),
	"fase1_ex2":      preload("res://assets/Audios/Fase1Ex2.mp3"),
	"fase2_ex1":      preload("res://assets/Audios/Fase2Ex1.mp3"),
	"fase2_ex2":      preload("res://assets/Audios/Fase2Ex2.mp3"),
	"jogar":          preload("res://assets/Audios/Jogar.mp3"),
	"sair":           preload("res://assets/Audios/Sair.mp3"),
	"voltar":         preload("res://assets/Audios/Voltar.mp3"),
}

# Chaves que são narrações longas – usam o player de narração dedicado
const CHAVES_NARRACAO: Array = [
	"fase1_ex1", "fase1_ex2", "fase2_ex1", "fase2_ex2",
	"digiteSeuNome", "ecoCityQuest"
]

var player_sfx: AudioStreamPlayer       # efeitos curtos (jogar, voltar, ajuda…)
var player_narracao: AudioStreamPlayer  # narrações longas de cada fase

func _ready() -> void:
	player_sfx = AudioStreamPlayer.new()
	player_sfx.bus = "Master"
	add_child(player_sfx)

	player_narracao = AudioStreamPlayer.new()
	player_narracao.bus = "Master"
	player_narracao.volume_db = -3.0
	add_child(player_narracao)

# Toca um áudio pelo nome da chave
func tocar(nome_audio: String) -> void:
	if not sons.has(nome_audio):
		print("[GerenciadorAudio] Áudio não encontrado: ", nome_audio)
		return

	if nome_audio in CHAVES_NARRACAO:
		player_narracao.stream = sons[nome_audio]
		player_narracao.play()
	else:
		player_sfx.stream = sons[nome_audio]
		player_sfx.play()

# Para apenas a narração (útil ao sair de uma tela no meio da narração)
func parar_narracao() -> void:
	player_narracao.stop()

# Para todos os sons
func parar_tudo() -> void:
	player_sfx.stop()
	player_narracao.stop()
