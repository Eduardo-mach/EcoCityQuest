extends Node
# Autoload responsável por controlar a navegação entre fases/exercícios

var fase_atual: int = 1
var exercicio_atual: int = 2

func avancar_exercicio() -> void:
	exercicio_atual += 1
	# Substitua pelo caminho da próxima cena quando ela existir
	# get_tree().change_scene_to_file("res://fases/fase1_exercicio3/Fase1Exercicio3.tscn")
	print("[GerenciadorJogo] Avançar para Fase ", fase_atual, " - Exercício ", exercicio_atual)

func voltar_exercicio() -> void:
	# Substitua pelo caminho da cena anterior / menu de fases
	# get_tree().change_scene_to_file("res://menu/MenuFases.tscn")
	print("[GerenciadorJogo] Voltar")
