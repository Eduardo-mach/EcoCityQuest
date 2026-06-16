extends Node

# Dados do jogador atual
var nome_jogador: String = ""
var fase_atual: int = 1
var exercicio_atual: int = 1

# Estrutura para o Ranking (Lista de dicionários)
var ranking: Array = []

const CAMINHO_SALVAMENTO = "user://ranking_ecocity.json"

func _ready():
	carregar_ranking()

# Define o nome do aluno e reseta o progresso para o início
func iniciar_novo_jogo(nome: String):
	nome_jogador = nome
	fase_atual = 1
	exercicio_atual = 1
	print("Jogo iniciado para o aluno: ", nome_jogador)

# Avança o fluxo do jogo com base na sua lista de exercícios
func avancar_exercicio():
	if fase_atual == 1 and exercicio_atual == 1:
		exercicio_atual = 2 # Vai pro Tapar Buraco/Árvores
	elif fase_atual == 1 and exercicio_atual == 2:
		fase_atual = 2
		exercicio_atual = 1 # Vai pra Casinha Ecológica
	elif fase_atual == 2 and exercicio_atual == 1:
		exercicio_atual = 2 # Vai pro Caça Palavras
	elif fase_atual == 2 and exercicio_atual == 2:
		finalizar_jogo()

# Função para salvar a pontuação no Ranking ao terminar o jogo
func finalizar_jogo():
	print("Parabéns, ", nome_jogador, "! Você concluiu o EcoCity Quest.")
	
	# Exemplo simples de pontuação baseada em tempo ou acertos (ajuste depois)
	var nova_pontuacao = {
		"nome": nome_jogador,
		"fase_maxima": fase_atual
	}
	
	ranking.append(nova_pontuacao)
	salvar_ranking()

# Salva o ranking em um arquivo JSON local para persistir os dados
func salvar_ranking():
	var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.WRITE)
	if arquivo:
		var dados_json = JSON.stringify(ranking)
		arquivo.store_string(dados_json)
		arquivo.close()

# Carrega o ranking salvo anteriormente ao abrir o jogo
func carregar_ranking():
	if FileAccess.file_exists(CAMINHO_SALVAMENTO):
		var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.READ)
		var conteudo = arquivo.get_as_text()
		arquivo.close()
		
		var json = JSON.new()
		if json.parse(conteudo) == OK:
			ranking = json.get_data()
