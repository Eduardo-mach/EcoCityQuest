extends Node

signal par_encontrado(id_carta: String)

var cartas_selecionadas: Array = []
var tabuleiro: Array = []

func inicializar_jogo() -> Array:
	var ids = [
		"arvore_nativa",
		"painel_solar",
		"lixeira_reciclagem",
		"bici_compartilhada",
		"carro_eletrico",
        "horta_comunitaria"
	]
	tabuleiro = ids + ids
	tabuleiro.shuffle()
	cartas_selecionadas.clear()
	return tabuleiro

func escolher_carta(index: int) -> Dictionary:
	cartas_selecionadas.append(index)

	if cartas_selecionadas.size() == 2:
		var primeira = cartas_selecionadas[0]
		var segunda = cartas_selecionadas[1]
		cartas_selecionadas.clear()

		if tabuleiro[primeira] == tabuleiro[segunda]:
			var id_carta = tabuleiro[primeira]
			emit_signal("par_encontrado", id_carta)
			return {"status": "acertou"}
		else:
			return {"status": "errou"}

	return {"status": "continuar"}


func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_timer_exercicio_timeout() -> void:
	pass # Replace with function body.
