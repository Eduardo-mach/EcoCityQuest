extends Node

var nome_jogador: String = ""
var fase_atual: int = 1
var exercicio_atual: int = 1
var ranking: Array = []
var pontuacao_total: int = 0   # acumula pontos de todos os exercícios

const CAMINHO_SALVAMENTO = "user://ranking_ecocity.json"

@onready var musica_fundo = AudioStreamPlayer.new()

var fases = {
	1: {
		1: "res://scenes/JogoMemoria.tscn",
		2: "res://Pontuacao/tela_parabens.tscn",
		3: "res://Pontuacao/PontuacaoMemoria.tscn",
		4: "res://scenes/JogoTelhado.tscn",
		5: "res://Pontuacao/tela_parabens.tscn",
		6: "res://Pontuacao/PontuacaoTelhado.tscn"
	},
	2: {
		1: "res://Fase2/Exercicio1/tela_caca_palavras.tscn",
		2: "res://Pontuacao/tela_parabens.tscn",
		3: "res://Pontuacao/PontuacaoCacaPalavras.tscn",
		4: "res://Fase2/Exercicio2/conserte_a_rua_tscn.tscn",
		5: "res://Pontuacao/tela_parabens.tscn",
		6: "res://Pontuacao/PontuacaoRua.tscn"
	}
}

func _ready():
	carregar_ranking()
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
	pontuacao_total = 0
	print("Jogo iniciado para o aluno: ", nome_jogador)
	carregar_exercicio()

func carregar_exercicio():
	if fases.has(fase_atual) and fases[fase_atual].has(exercicio_atual):
		var caminho = fases[fase_atual][exercicio_atual]
		get_tree().change_scene_to_file(caminho)
	else:
		print("Não há mais exercícios. Finalizando jogo.")
		finalizar_jogo(pontuacao_total)

func avancar_exercicio():
	exercicio_atual += 1
	if not fases[fase_atual].has(exercicio_atual):
		fase_atual += 1
		exercicio_atual = 1
	carregar_exercicio()

# Funções de pontuação
func adicionar_pontos(valor: int) -> void:
	pontuacao_total += valor
	print("Pontuação atual: ", pontuacao_total)

func get_pontuacao() -> int:
	return pontuacao_total

# Ranking
func finalizar_jogo(pontuacao_final: int):
	var nome_salvar = nome_jogador if nome_jogador != "" else "Jogador"
	var pontuacao_reduzida : int = int(pontuacao_final / 10)
	print("Parabéns, ", nome_salvar, "! Jogo concluído com ", pontuacao_reduzida, " pontos.")
 
	var nova_pontuacao = {"nome": nome_salvar, "pontuacao": pontuacao_reduzida}
	ranking.append(nova_pontuacao)

	# Ordenação manual
	for i in range(ranking.size()):
		for j in range(i + 1, ranking.size()):
			if int(ranking[j]["pontuacao"]) > int(ranking[i]["pontuacao"]):
				var temp = ranking[i]
				ranking[i] = ranking[j]
				ranking[j] = temp

	if ranking.size() > 3:
		ranking.resize(3)

	salvar_ranking()


func salvar_ranking():
	var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.WRITE)
	if arquivo:
		var dados_json = JSON.stringify(ranking)
		arquivo.store_string(dados_json)
		arquivo.close()

func carregar_ranking():
	if FileAccess.file_exists(CAMINHO_SALVAMENTO):
		var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.READ)
		if arquivo:
			var conteudo = arquivo.get_as_text()
			arquivo.close()
			var json = JSON.new()
			if json.parse(conteudo) == OK:
				var dados = json.get_data()
				if dados is Array:
					ranking = dados
