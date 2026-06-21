extends Node
# Autoload responsável por tocar narrações/efeitos sonoros do jogo

# Substitua os caminhos abaixo pelos seus arquivos de áudio reais (.ogg ou .wav)
# em res://assets/audios/
var sons: Dictionary = {
	# "audio_intro_f1e2": preload("res://assets/audios/intro_f1e2.ogg"),
	# "audio_sucesso_telhado": preload("res://assets/audios/sucesso_telhado.ogg"),
	# "audio_erro_telhado": preload("res://assets/audios/erro_telhado.ogg"),
	# "audio_parabens_fase1": preload("res://assets/audios/parabens_fase1.ogg"),
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
