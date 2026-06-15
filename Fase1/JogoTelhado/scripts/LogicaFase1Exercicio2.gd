extends Node
# JOGO DE ARRASTAR - FASE 1 EXERCÍCIO 2 (Termine o Telhado)

signal tocar_narracao(nome_audio)
signal objetivo_concluido(tipo_objetivo)
signal exercicio_finalizado

# Estado do exercício
var telhado_concluido: bool = false

func inicializar_exercicio():
	telhado_concluido = false

	# Aguarda um instante para a tela carregar e pede ao frontend para tocar a introdução
	await get_tree().create_timer(0.5).timeout
	emit_signal("tocar_narracao", "audio_intro_f1e2") # "Ajude a terminar o telhado..."

# O frontend chama essa função quando o aluno arrasta um item até o alvo
func processar_item_arrastado(objeto: String, alvo: String) -> Dictionary:
	if alvo == "telhado":
		if objeto == "placa_solar":
			if not telhado_concluido:
				telhado_concluido = true
				emit_signal("objetivo_concluido", "telhado")
				emit_signal("tocar_narracao", "audio_sucesso_telhado") # "Muito bem! Telhado com energia solar."
				_verificar_fim_do_exercicio()
				return {"sucesso": true, "mensagem": "Telhado concluído com placas solares!"}
		else:
			emit_signal("tocar_narracao", "audio_erro_telhado") # "Isso não é uma boa opção para o telhado."
			return {"sucesso": false, "mensagem": "Objeto inválido para o telhado."}

	return {"sucesso": false, "mensagem": "Alvo não reconhecido."}

# Verifica se a meta do exercício foi atingida
func _verificar_fim_do_exercicio():
	if telhado_concluido:
		emit_signal("exercicio_finalizado")
		emit_signal("tocar_narracao", "audio_parabens_fase1")

		# Pequeno delay para o aluno ouvir os parabéns antes de mudar de tela
		await get_tree().create_timer(3.0).timeout

		# Chama o gerenciador global para ir para a próxima tela
		if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()
