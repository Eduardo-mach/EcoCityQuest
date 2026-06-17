extends TextureRect

func _can_drop_data(_at_position, _data):
	return true

func _drop_data(_at_position, data):
	# Importante: Como o script do botão envia o seu 'name',
	# ele vai enviar "Botao Entulho" com espaço exatamente!
	if get_parent().has_method("processar_escolha"):
		get_parent().processar_escolha(data)
