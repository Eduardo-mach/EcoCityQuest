extends Node

#JOGO DE ARRASTAR
# Sinais para o frontend saber o que tocar de áudio e quando encerrar
signal tocar_narracao(nome_audio)
signal objetivo_concluido(tipo_objetivo)
signal exercicio_finalizado

# Estado do exercício
var buraco_tapado: bool = false
var arvores_plantadas: int = 0
const TOTAL_ARVORES_NECESSARIAS: int = 3

func inicializar_exercicio():
	buraco_tapado = false
	arvores_plantadas = 0
	
	# Aguarda um instante para a tela carregar e pede para o frontend tocar a introdução
	await get_tree().create_timer(0.5).timeout
	emit_signal("tocar_narracao", "audio_intro_f1e2") # "Ajude a consertar a rua..."

# O frontend chama essa função quando o aluno arrasta um objeto até o alvo
func processar_item_arrastado(objeto: String, alvo: String) -> Dictionary:
	# Caso 1: Aluno tentou consertar a rua
	if alvo == "buraco_via":
		if objeto == "asfalto_ecologico" or objeto == "paralelepipedo":
			if not buraco_tapado:
				buraco_tapado = true
				emit_signal("objetivo_concluido", "buraco")
				emit_signal("tocar_narracao", "audio_sucesso_buraco") # "Muito bem! A rua está segura."
				_verificar_fim_do_exercicio()
				return {"sucesso": true, "mensagem": "Buraco tapado!"}
		else:
			emit_signal("tocar_narracao", "audio_erro_buraco") # "Isso não serve para tapar o buraco."
			return {"sucesso": false, "mensagem": "Objeto inválido para a via."}
			
	# Caso 2: Aluno tentou plantar uma árvore na calçada/canteiro
	elif alvo == "canteiro_calcada":
		if objeto == "muda_arvore":
			if arvores_plantadas < TOTAL_ARVORES_NECESSARIAS:
				arvores_plantadas += 1
				emit_signal("objetivo_concluido", "arvore")
				
				if arvores_plantadas < TOTAL_ARVORES_NECESSARIAS:
					emit_signal("tocar_narracao", "audio_mais_arvores") # "Continue plantando!"
				else:
					emit_signal("tocar_narracao", "audio_sucesso_arvores") # "Ótimo! A calçada está mais verde."
				
				_verificar_fim_do_exercicio()
				return {"sucesso": true, "progresso": arvores_plantadas}
		else:
			emit_signal("tocar_narracao", "audio_erro_arvore")
			return {"sucesso": false, "mensagem": "Aqui é lugar de plantar árvores!"}

	return {"sucesso": false, "mensagem": "Alvo não reconhecido."}

# Verifica se todas as metas ecológicas da fase foram batidas
func _verificar_fim_do_exercicio():
	if buraco_tapado and arvores_plantadas >= TOTAL_ARVORES_NECESSARIAS:
		emit_signal("exercicio_finalizado")
		emit_signal("tocar_narracao", "audio_parabens_fase1")
		
		# Pequeno delay para o aluno ouvir os parabéns antes de mudar de tela
		await get_tree().create_timer(3.0).timeout
		
		# Chama o seu gerenciador global para ir para a Tela de Parabéns / Fase 2
		if ResourceLoader.exists("res://GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()
