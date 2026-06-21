extends Node

var ordem_exercicios = [
	# Fase 1
	"res://scenes/JogoMemoria.tscn",
	"res://Pontuacao/PontuacaoMemoria.tscn",   # pontuação do exercício 1

	"res://scenes/JogoTelhado.tscn",
	"res://Pontuacao/PontuacaoTelhado.tscn",   # pontuação do exercício 2

	# Fase 2
	"res://Fase2/Exercicio1/tela_caca_palavras.tscn",
	"res://Pontuacao/PontuacaoCacaPalavras.tscn",   # pontuação do exercício 3

	"res://Fase2/Exercicio2/conserte_a_rua_tscn.tscn",
	"res://Pontuacao/PontuacaoRua.tscn"   # pontuação do exercício 4

]
var indice_atual: int = 0
var pontuacao_total: int = 0

func _ready():
	carregar_exercicio(indice_atual)

func carregar_exercicio(indice: int) -> void:
	if indice >= 0 and indice < ordem_exercicios.size():
		get_tree().change_scene_to_file(ordem_exercicios[indice])

func avancar_exercicio() -> void:
	indice_atual += 1
	if indice_atual < ordem_exercicios.size():
		carregar_exercicio(indice_atual)
	else:
		print("Fim do jogo! Todas as fases concluídas.")

func voltar_exercicio() -> void:
	indice_atual = max(indice_atual - 1, 0)
	carregar_exercicio(indice_atual)

# Função para somar pontos
func adicionar_pontos(valor: int) -> void:
	pontuacao_total += valor
	print("Pontuação atual: ", pontuacao_total)

# Função para obter pontuação
func get_pontuacao() -> int:
	return pontuacao_total
