extends Node
# Autoload responsável por tocar narrações/efeitos sonoros do jogo

# Substitua os caminhos abaixo pelos seus arquivos de áudio reais (.ogg ou .wav)
# em res://assets/audios/
var sons: Dictionary = {
	# "audio_intro_memoria": preload("res://assets/audios/intro_memoria.ogg"),
	# "audio_acerto_par": preload("res://assets/audios/acerto_par.ogg"),
	# "audio_erro_par": preload("res://assets/audios/erro_par.ogg"),
	# "audio_parabens_memoria": preload("res://assets/audios/parabens_memoria.ogg"),
	# "audio_ajuda_memoria": preload("res://assets/audios/ajuda_memoria.ogg"),
}

var player: AudioStreamPlayer

func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)

func tocar(nome_audio: String) -> void:
	if sons.has(nome_audio):
		player.stream = sons[nome_audio]
		player.play()
	else:
		# Enquanto não houver áudios adicionados, apenas registra no log
		print("[GerenciadorAudio] Tocando: ", nome_audio)
