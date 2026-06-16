extends TextureRect

# Essa função roda automaticamente quando você clica e arrasta a imagem
func _get_drag_data(_at_position):
	# Cria uma cópia visual da imagem para seguir o mouse enquanto arrasta
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = expand_mode
	preview.stretch_mode = stretch_mode
	preview.custom_minimum_size = custom_minimum_size
	
	# Centraliza a imagem embaixo do ponteiro do mouse
	preview.position = -custom_minimum_size / 2
	
	# Cria um controle temporário para segurar o preview
	var preview_control = Control.new()
	preview_control.add_child(preview)
	set_drag_preview(preview_control)
	
	# Passa o nome do próprio nó como a "informação" do que está sendo arrastado
	return name
