extends Node

# Função para registrar uma nova pontuação e ordenar o ranking
func registrar_pontuacao(nome: String, erros: int, tempo_segundos: float):
	# Quanto menor o tempo e menor o número de erros, melhor a pontuação
	var pontuacao_final = int(10000 - (erros * 100) - tempo_segundos)
	if pontuacao_final < 0: pontuacao_final = 0
	
	var novo_registro = {
		"nome": nome,
		"pontuacao": pontuacao_final,
		"erros": erros,
		"tempo": tempo_segundos
	}
	
	# Puxa o ranking atual
	var gerenciador = get_node("/root/GerenciadorJogo")
	gerenciador.ranking.append(novo_registro)
	
	# Ordena do maior para o menor usando uma função customizada
	gerenciador.ranking.sort_custom(func(a, b): return a["pontuacao"] > b["pontuacao"])
	
	# Garante que só fiquem os 5 melhores no Top 5
	if gerenciador.ranking.size() > 5:
		gerenciador.ranking.resize(5)
		
	gerenciador.salvar_ranking()