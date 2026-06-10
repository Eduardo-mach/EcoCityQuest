extends Node

#JOGO DA MEMORIA
# Sinais para avisar o frontend o que aconteceu no backend
signal par_encontrado(id_carta)
signal par_errado(id_carta1, id_carta2)
signal jogo_da_memoria_concluido

# Banco de dados das cartas (Imagens ecológicas reais)
# O frontend usará esses nomes para carregar as fotos correspondentes
var lista_itens_ecologicos = [
	"arvore_nativa",
	"painel_solar",
	"lixeira_reciclagem",
	"bici_compartilhada",
	"carro_eletrico",
	"horta_comunitaria"
]

var cartas_tabuleiro: Array = []
var carta_selecionada_1: int = -1
var carta_selecionada_2: int = -1
var pares_descobertos: int = 0
var total_pares: int = 0

# Prepara o jogo do zero
func inicializar_jogo():
	cartas_tabuleiro.clear_cache()
	pares_descobertos = 0
	carta_selecionada_1 = -1
	carta_selecionada_2 = -1
	total_pares = lista_itens_ecologicos.size()
	
	# Duplica os itens para criar os pares
	for item in lista_itens_ecologicos:
		cartas_tabuleiro.append(item)
		cartas_tabuleiro.append(item)
	
	# Embaralha o tabuleiro de forma aleatória
	cartas_tabuleiro.shuffle()
	return cartas_tabuleiro

# Função principal que o frontend chama quando o aluno clica em uma carta
func escolher_carta(posicao_index: int):
	# Evita cliques repetidos na mesma carta ou se já houver duas cartas sendo checadas
	if posicao_index == carta_selecionada_1 or carta_selecionada_2 != -1:
		return
		
	if carta_selecionada_1 == -1:
		carta_selecionada_1 = posicao_index
		# Retorna para o frontend saber qual carta foi ativada
		return {"status": "primeira_carta", "item": cartas_tabuleiro[posicao_index]}
	else:
		carta_selecionada_2 = posicao_index
		var item1 = cartas_tabuleiro[carta_selecionada_1]
		var item2 = cartas_tabuleiro[carta_selecionada_2]
		
		# Se os nomes forem iguais, temos um par ecológico
		if item1 == item2:
			pares_descobertos += 1
			emit_signal("par_encontrado", item1)
			
			# Reseta a seleção para a próxima tentativa
			_resetar_selecao()
			
			# Verifica se o aluno limpou o tabuleiro
			if pares_descobertos == total_pares:
				emit_signal("jogo_da_memoria_concluido")
				# Avisa o gerenciador geral para avançar de fase
				if ResourceLoader.exists("res://GerenciadorJogo.gd"):
					get_node("/root/GerenciadorJogo").avancar_exercicio()
					
			return {"status": "acertou", "item": item1}
		else:
			# Se errou, avisa o frontend para desvirar as duas após um pequeno delay
			emit_signal("par_errado", carta_selecionada_1, carta_selecionada_2)
			
			# Usamos um timer rápido para o jogador conseguir ver a segunda carta antes de resetar
			var timer = get_tree().create_timer(1.0)
			await timer.timeout
			
			_resetar_selecao()
			return {"status": "errou"}

func _resetar_selecao():
	carta_selecionada_1 = -1
	carta_selecionada_2 = -1	