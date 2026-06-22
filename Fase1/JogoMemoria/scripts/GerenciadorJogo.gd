extends Node
# Autoload responsável por controlar a navegação entre fases/exercícios

var fase_atual: int = 1
var exercicio_atual: int = 3

func avancar_exercicio() -> void:
	exercicio_atual += 1

	# Troca de cena (quando existir)
	# get_tree().change_scene_to_file("res://fases/fase1_exercicio4/Fase1Exercicio4.tscn")

	# Monta chave de áudio e toca
	var chave_audio = "fase%d_ex%d" % [fase_atual, exercicio_atual]
	if Engine.has_singleton("GerenciadorAudio"):
		GerenciadorAudio.tocar(chave_audio)

	print("[GerenciadorJogo] Avançar para Fase ", fase_atual, " - Exercício ", exercicio_atual)

func voltar_exercicio() -> void:
	# Troca de cena (quando existir)
	# get_tree().change_scene_to_file("res://menu/MenuFases.tscn")

	# Monta chave de áudio e toca
	var chave_audio = "fase%d_ex%d" % [fase_atual, exercicio_atual]
	if Engine.has_singleton("GerenciadorAudio"):
		GerenciadorAudio.tocar(chave_audio)

	print("[GerenciadorJogo] Voltar para Fase ", fase_atual, " - Exercício ", exercicio_atual)

func iniciar_fase(fase: int, exercicio: int) -> void:
	fase_atual = fase
	exercicio_atual = exercicio

	# Troca de cena (quando existir)
	# get_tree().change_scene_to_file("res://fases/fase%d_ex%d/Fase%dEx%d.tscn" % [fase, exercicio, fase, exercicio])

	# Monta chave de áudio e toca
	var chave_audio = "fase%d_ex%d" % [fase_atual, exercicio_atual]
	if Engine.has_singleton("GerenciadorAudio"):
		GerenciadorAudio.tocar(chave_audio)

	print("[GerenciadorJogo] Iniciar Fase ", fase_atual, " - Exercício ", exercicio_atual)
