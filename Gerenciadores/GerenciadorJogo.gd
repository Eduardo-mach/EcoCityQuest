extends Node

var nome_jogador: String = ""
var fase_atual: int = 1
var exercicio_atual: int = 1

@onready var musica_fundo = AudioStreamPlayer.new()

var fases = {
	1: {
		1: "res://Fase1/JogoMemoria/Exercicio1/JogoMemoria.tscn",
		2: "res://Fase1/JogoTelhado/Exercicio2/JogoTelhado.tscn",
	},
	2: {
		1: "res://scenes/tela_caca_palavras.tscn",
		2: "res://scenes/conserte_a_rua_tscn.tscn",
	}
}

func _ready():
	call_deferred("add_child", musica_fundo)
	musica_fundo.volume_db = -12
	musica_fundo.play()
	call_deferred("_carregar_menu")

func _carregar_menu():
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

# Chamado pelo menu quando o jogador digitar o nome
func iniciar_novo_jogo(nome: String):
	nome_jogador = nome
	fase_atual = 1
	exercicio_atual = 1
	print("Jogo iniciado para o aluno: ", nome_jogador)
	carregar_exercicio()

func carregar_exercicio():
	if fases.has(fase_atual) and fases[fase_atual].has(exercicio_atual):
		var caminho = fases[fase_atual][exercicio_atual]
		print("Carregando cena:", caminho)
		var result = get_tree().change_scene_to_file(caminho)
		if result != OK:
			print("Erro ao carregar cena:", caminho)
	else:
		print("Não há mais exercícios. Finalizando jogo.")
		finalizar_jogo()

func avancar_exercicio():
	exercicio_atual += 1
	if not fases[fase_atual].has(exercicio_atual):
		fase_atual += 1
		exercicio_atual = 1
	carregar_exercicio()

func finalizar_jogo():
	var nome_salvar = nome_jogador if nome_jogador != "" else "Jogador"
	print("Parabéns, ", nome_salvar, "! Jogo concluído.")
