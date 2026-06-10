extends Node

#CASA SUSTENTAVEL

signal item_posicionado_com_sucesso(nome_item, tipo_melhoria)
signal casa_sustentavel_completa

# Controle das melhorias sustentaveis da casa
var tem_teto_verde: bool = false
var tem_painel_solar: bool = false
var tem_sistema_chuva: bool = false # Captação de água

func inicializar_exercicio():
	tem_teto_verde = false
	tem_painel_solar = false
	tem_sistema_chuva = false
	print("Exercício da Casa Ecológica iniciado. Melhore a estrutura!")

# O frontend chama quando o aluno arrasta um elemento até a estrutura da casa
func aplicar_melhoria_arquitetura(objeto: String, alvo: String) -> Dictionary:
	# Validação do Teto/Telhado
	if alvo == "telhado_casa":
		if objeto == "teto_jardim_sustentavel" or objeto == "grama_telhado":
			if not tem_teto_verde:
				tem_teto_verde = true
				emit_signal("item_posicionado_com_sucesso", objeto, "isolamento_termico")
				_checar_conclusao()
				return {"sucesso": true, "efeito": "Reduz a temperatura da casa naturalmente!"}
		elif objeto == "placa_fotovoltaica":
			if not tem_painel_solar:
				tem_painel_solar = true
				emit_signal("item_posicionado_com_sucesso", objeto, "energia_limpa")
				_checar_conclusao()
				return {"sucesso": true, "efeito": "Gera energia limpa do sol!"}
		else:
			return {"sucesso": false, "mensagem": "Esse material não traz benefícios ecológicos para o telhado."}
			
	# Validação do Quintal/Laterais (Captação de água)
	elif alvo == "calha_quintal":
		if objeto == "cisterna_agua_chuva" or objeto == "barril_captacao":
			if not tem_sistema_chuva:
				tem_sistema_chuva = true
				emit_signal("item_posicionado_com_sucesso", objeto, "reuso_agua")
				_checar_conclusao()
				return {"sucesso": true, "efeito": "Armazena água para regar as plantas!"}
		else:
			return {"sucesso": false, "mensagem": "Isso não ajuda a poupar recursos hídricos."}

	return {"sucesso": false, "mensagem": "Local de posicionamento inválido."}

func _checar_conclusao():
	# O exercício termina quando o aluno aplicar todas as 3 melhorias essenciais
	if tem_teto_verde and tem_painel_solar and tem_sistema_chuva:
		emit_signal("casa_sustentavel_completa")
		
		# Avança para o Caça-Palavras automaticamente através do seu gerenciador global
		if ResourceLoader.exists("res://GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()