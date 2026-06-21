extends Node

var sons: Dictionary = {
	"fase1_ex2": preload("res://assets/Audios/Fase1Ex2.mp3"),
}

var player: AudioStreamPlayer

func _ready() -> void:
	player = AudioStreamPlayer.new()
	player.bus = "Master"
	player.volume_db = 0
	add_child(player)

func tocar(nome_audio: String) -> void:
	if sons.has(nome_audio):
		player.stream = sons[nome_audio]
		player.play()
	else:
		print("[GerenciadorAudio] Áudio não encontrado: ", nome_audio)
