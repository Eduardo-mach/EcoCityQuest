extends Node
# JOGO DA MEMÓRIA

# Sinais para avisar o frontend o que aconteceu no backend
signal par_encontrado(id_carta)
signal par_errado(id_carta1, id_carta2)
signal jogo_da_memoria_concluido
signal resultado_jogada(resultado) # emitido após escolher_carta() processar (inclui casos com delay)

# Banco de dados das cartas (Imagens ecológicas reais)
var lista_itens_ecologicos: Array = [
	"arvore_nativa",
	"painel_solar",
	"lixeira_reciclagem",
	"bici_compartilhada",
	"carro_eletrico",
	"horta_comunitaria",
]

var cartas_tabuleiro: Array = []
var carta_selecionada_1: int = -1
var carta_selecionada_2: int = -1
var pares_descobertos: int = 0
var total_pares: int = 0

# Prepara o jogo do zero
func inicializar_jogo() -> Array:
	cartas_tabuleiro.clear()
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

# Função principal chamada quando o aluno clica em uma carta
func escolher_carta(posicao_index: int) -> Dictionary:
	# Evita cliques repetidos na mesma carta ou se já houver duas cartas sendo checadas
	if posicao_index == carta_selecionada_1 or carta_selecionada_2 != -1:
		var resultado_ignorado = {"status": "ignorado"}
		emit_signal("resultado_jogada", resultado_ignorado)
		return resultado_ignorado

	if carta_selecionada_1 == -1:
		# Primeira carta
		carta_selecionada_1 = posicao_index
		var resultado = {"status": "primeira_carta", "item": cartas_tabuleiro[posicao_index]}
		emit_signal("resultado_jogada", resultado)
		return resultado
	else:
		# Segunda carta
		carta_selecionada_2 = posicao_index
		var item1 = cartas_tabuleiro[carta_selecionada_1]
		var item2 = cartas_tabuleiro[carta_selecionada_2]

		# 🔑 Emitir resultado da segunda carta para o frontend revelar
		var resultado_segunda = {"status": "segunda_carta", "item": item2}
		emit_signal("resultado_jogada", resultado_segunda)

		# Comparação
		if item1 == item2:
			pares_descobertos += 1
			emit_signal("par_encontrado", item1)

			_resetar_selecao()

			var resultado = {"status": "acertou", "item": item1}
			emit_signal("resultado_jogada", resultado)

			# Verifica se o tabuleiro foi concluído
			if pares_descobertos == total_pares:
				emit_signal("jogo_da_memoria_concluido")
				if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
					get_node("/root/GerenciadorJogo").avancar_exercicio()

			return resultado
		else:
			# Erro: avisa o frontend para desvirar as duas cartas
			emit_signal("par_errado", carta_selecionada_1, carta_selecionada_2)

			# Delay para o jogador ver a segunda carta
			var timer = get_tree().create_timer(1.0)
			await timer.timeout

			_resetar_selecao()

			var resultado = {"status": "errou"}
			emit_signal("resultado_jogada", resultado)
			return resultado

func _resetar_selecao() -> void:
	carta_selecionada_1 = -1
	carta_selecionada_2 = -1
