extends Node
# Script de gerenciamento de áudio (sem autoload)

var sons: Dictionary = {
	"ajuda": preload("res://assets/Audios/Ajuda.mp3"),
	"avancar": preload("res://assets/Audios/Avançar.mp3"),
	"fase1_ex1": preload("res://assets/Audios/Fase1Ex1.mp3"),
	"fase1_ex2": preload("res://assets/Audios/Fase1Ex2.mp3"),
	"fase2_ex1": preload("res://assets/Audios/Fase2Ex1.mp3"),
	"fase2_ex2": preload("res://assets/Audios/Fase2Ex2.mp3"),
	"jogar": preload("res://assets/Audios/Jogar.mp3"),
	"sair": preload("res://assets/Audios/Sair.mp3"),
	"voltar": preload("res://assets/Audios/Voltar.mp3"),
	"Eco":preload("res://assets/Audios/EcoCityQuest.mp3")
}

var player: AudioStreamPlayer

func _ready() -> void:
	player = AudioStreamPlayer.new()
	player.bus = "Master"
	add_child(player)

func tocar(nome_audio: String) -> void:
	if sons.has(nome_audio):
		player.stream = sons[nome_audio]
		player.play()
	else:
		print("[GerenciadorAudio] Áudio não encontrado: ", nome_audio)
		
