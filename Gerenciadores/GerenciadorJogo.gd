extends Node

# Dados do jogador atual
var nome_jogador: String = ""
var fase_atual: int = 1
var exercicio_atual: int = 1

# Estrutura para o Ranking (Lista de dicionários)
var ranking: Array = []

const CAMINHO_SALVAMENTO = "user://ranking_ecocity.json"

# 🎵 Criamos o tocador de áudio por código
@onready var musica_fundo = AudioStreamPlayer.new()

func _ready():
	carregar_ranking()
	
	# 🎵 Configura e solta a trilha sonora assim que o jogo abre
	add_child(musica_fundo)
	
	# ⚠️ ATENÇÃO: Troque "musica_jogo.mp3" pelo nome EXATO do arquivo que você baixou
	musica_fundo.stream = load("res://assets/musica_jogo.mp3") 
	
	musica_fundo.volume_db = -12 # Diminui um pouco o volume para ficar agradável de fundo
	musica_fundo.play()

# Define o nome do aluno e reseta o progresso para o início
func iniciar_novo_jogo(nome: String):
	nome_jogador = nome
	fase_atual = 1
	exercicio_atual = 1
	print("Jogo iniciado para o aluno: ", nome_jogador)

# Avança o fluxo do jogo com base na sua lista de exercícios
func avancar_exercicio():
	if fase_atual == 1 and exercicio_atual == 1:
		exercicio_atual = 1
	elif fase_atual == 1 and exercicio_atual == 2:
		fase_atual = 1
		exercicio_atual = 1
	elif fase_atual == 2 and exercicio_atual == 1:
		exercicio_atual = 2
	elif fase_atual == 2 and exercicio_atual == 2:
		fase_atual = 2
		exercicio_atual = 2
		# Aqui você decide o que acontece ao terminar todos os exercícios
		finalizar_jogo(1000) # exemplo de pontuação final

# Função de finalização estável e direta
func finalizar_jogo(pontuacao_final: int):
	var nome_salvar = nome_jogador
	if nome_salvar == "":
		nome_salvar = "Jogador"

	# 🎯 Dividimos o valor por 10 para reduzir (ex: de 9978 para 997)
	var pontuacao_reduzida : int = int(pontuacao_final / 10)

	print("Parabéns, ", nome_salvar, "! Jogo concluído com ", pontuacao_reduzida, " pontos.")
	
	var nova_pontuacao = {
		"nome": nome_salvar,
		"pontuacao": pontuacao_reduzida
	}
	
	ranking.append(nova_pontuacao)
	
	# Ordenação manual simplificada para evitar lambdas que quebram o compilador
	for i in range(ranking.size()):
		for j in range(i + 1, ranking.size()):
			if int(ranking[j]["pontuacao"]) > int(ranking[i]["pontuacao"]):
				var temp = ranking[i]
				ranking[i] = ranking[j]
				ranking[j] = temp
	
	# Mantém apenas as 3 melhores pontuações
	if ranking.size() > 3:
		ranking.resize(3)
		
	salvar_ranking()

# Salva o ranking em um arquivo JSON local
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
		if arquivo:
			var conteudo = arquivo.get_as_text()
			arquivo.close()
			
			var json = JSON.new()
			if json.parse(conteudo) == OK:
				var dados = json.get_data()
				if dados is Array:
					ranking = dados
