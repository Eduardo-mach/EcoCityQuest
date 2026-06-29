extends Control

const COR_FUNDO     = Color(0.07, 0.35, 0.15)
const COR_PAINEL    = Color(0.98, 0.88, 0.30)
const COR_TEXTO_ESC = Color(0.1,  0.1,  0.1)
const COR_TEXTO_CLA = Color(1.0,  1.0,  1.0)
const COR_OURO      = Color(1.0,  0.80, 0.0)
const COR_PRATA     = Color(0.75, 0.75, 0.75)
const COR_BRONZE    = Color(0.8,  0.50, 0.20)
const COR_NORMAL    = Color(0.25, 0.25, 0.25)
const COR_BOTAO_VRD = Color(0.09, 0.55, 0.22)
const COR_BOTAO_VRM = Color(0.65, 0.10, 0.10)

func _ready() -> void:
	_construir_ui()

func _construir_ui() -> void:
	# ── 1. Fundo verde (cobre tudo) ────────────────────────────────────────
	var fundo = ColorRect.new()
	fundo.color = COR_FUNDO
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(fundo)

	# ── 2. ScrollContainer ocupa a tela inteira ────────────────────────────
	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)

	# ── 3. MarginContainer dá respiro interno ao scroll ────────────────────
	var margin = MarginContainer.new()
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_theme_constant_override("margin_left",   40)
	margin.add_theme_constant_override("margin_right",  40)
	margin.add_theme_constant_override("margin_top",    30)
	margin.add_theme_constant_override("margin_bottom", 30)
	scroll.add_child(margin)

	# ── 4. Painel amarelo (fundo do conteúdo) ─────────────────────────────
	var painel = PanelContainer.new()
	var estilo_painel = StyleBoxFlat.new()
	estilo_painel.bg_color = COR_PAINEL
	estilo_painel.set_corner_radius_all(16)
	painel.add_theme_stylebox_override("panel", estilo_painel)
	painel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(painel)

	# ── 5. VBox principal com todo o conteúdo ─────────────────────────────
	var inner = MarginContainer.new()
	inner.add_theme_constant_override("margin_left",   32)
	inner.add_theme_constant_override("margin_right",  32)
	inner.add_theme_constant_override("margin_top",    24)
	inner.add_theme_constant_override("margin_bottom", 24)
	painel.add_child(inner)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner.add_child(vbox)

	# ── Cabeçalho ─────────────────────────────────────────────────────────
	var lbl_trofeu = Label.new()
	lbl_trofeu.text = "🏆"
	lbl_trofeu.add_theme_font_size_override("font_size", 72)
	lbl_trofeu.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(lbl_trofeu)

	var lbl_titulo = Label.new()
	lbl_titulo.text = "RANKING GERAL"
	lbl_titulo.add_theme_font_size_override("font_size", 44)
	lbl_titulo.add_theme_color_override("font_color", COR_TEXTO_ESC)
	lbl_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(lbl_titulo)

	vbox.add_child(_sep())

	# ── Sessão atual ──────────────────────────────────────────────────────
	_secao_sessao_atual(vbox)

	vbox.add_child(_sep())

	# ── Top 5 histórico ───────────────────────────────────────────────────
	_secao_top5(vbox)

	vbox.add_child(_sep())

	# ── Botões ────────────────────────────────────────────────────────────
	_secao_botoes(vbox)

# ─── SESSÃO ATUAL ─────────────────────────────────────────────────────────────
func _secao_sessao_atual(vbox: VBoxContainer) -> void:
	if not has_node("/root/GerenciadorJogo") or not has_node("/root/GerenciadorRanking"):
		return

	var nome = GerenciadorJogo.nome_jogador
	if nome.strip_edges() == "":
		nome = "Jogador"

	var lbl = Label.new()
	lbl.text = "🎉  Parabéns, %s!" % nome
	lbl.add_theme_font_size_override("font_size", 28)
	lbl.add_theme_color_override("font_color", Color(0.05, 0.45, 0.05))
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(lbl)

	var gr = GerenciadorRanking
	var jogos = [
		["📝  Caça-Palavras",   gr.pontos_caca_palavras],
		["🚧  Conserte a Rua",  gr.pontos_rua],
		["🃏  Jogo da Memória", gr.pontos_memoria],
		["🏠  Jogo do Telhado", gr.pontos_telhado],
	]

	for jogo in jogos:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 8)

		var ln = Label.new()
		ln.text = jogo[0]
		ln.add_theme_font_size_override("font_size", 20)
		ln.add_theme_color_override("font_color", COR_TEXTO_ESC)
		ln.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(ln)

		var lp = Label.new()
		lp.text = str(jogo[1]) + " pts"
		lp.add_theme_font_size_override("font_size", 20)
		lp.add_theme_color_override("font_color", Color(0.05, 0.40, 0.05))
		hbox.add_child(lp)

		vbox.add_child(hbox)

	# Total
	vbox.add_child(_sep())

	var hbt = HBoxContainer.new()
	var lt = Label.new()
	lt.text = "TOTAL:"
	lt.add_theme_font_size_override("font_size", 26)
	lt.add_theme_color_override("font_color", COR_TEXTO_ESC)
	lt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbt.add_child(lt)

	var ltp = Label.new()
	ltp.text = str(gr.get_pontuacao_total()) + " pts"
	ltp.add_theme_font_size_override("font_size", 30)
	ltp.add_theme_color_override("font_color", Color(0.05, 0.45, 0.05))
	hbt.add_child(ltp)

	vbox.add_child(hbt)

# ─── TOP 5 HISTÓRICO ──────────────────────────────────────────────────────────
func _secao_top5(vbox: VBoxContainer) -> void:
	var lbl_hist = Label.new()
	lbl_hist.text = "🌟  TOP 5 – Melhores Jogadores de Todos os Tempos"
	lbl_hist.add_theme_font_size_override("font_size", 22)
	lbl_hist.add_theme_color_override("font_color", COR_TEXTO_ESC)
	lbl_hist.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_hist.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(lbl_hist)

	var ranking: Array = []
	if has_node("/root/GerenciadorJogo"):
		ranking = GerenciadorJogo.ranking

	if ranking.is_empty():
		var lbl_vazio = Label.new()
		lbl_vazio.text = "Seja o primeiro no ranking!"
		lbl_vazio.add_theme_font_size_override("font_size", 20)
		lbl_vazio.add_theme_color_override("font_color", COR_TEXTO_ESC)
		lbl_vazio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(lbl_vazio)
		return

	var medalhas = ["🥇", "🥈", "🥉", " 4º", " 5º"]
	var cores    = [COR_OURO, COR_PRATA, COR_BRONZE, COR_NORMAL, COR_NORMAL]

	for i in range(min(5, ranking.size())):
		var entrada = ranking[i]
		var linha = HBoxContainer.new()
		linha.add_theme_constant_override("separation", 12)

		var lbl_pos = Label.new()
		lbl_pos.text = medalhas[i]
		lbl_pos.add_theme_font_size_override("font_size", 24)
		lbl_pos.custom_minimum_size = Vector2(48, 0)
		linha.add_child(lbl_pos)

		var lbl_nome = Label.new()
		lbl_nome.text = str(entrada.get("nome", "?"))
		lbl_nome.add_theme_font_size_override("font_size", 22)
		lbl_nome.add_theme_color_override("font_color", cores[i])
		lbl_nome.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		linha.add_child(lbl_nome)

		var lbl_pts = Label.new()
		lbl_pts.text = str(entrada.get("pontuacao", 0)) + " pts"
		lbl_pts.add_theme_font_size_override("font_size", 22)
		lbl_pts.add_theme_color_override("font_color", COR_TEXTO_ESC)
		linha.add_child(lbl_pts)

		vbox.add_child(linha)

# ─── BOTÕES ────────────────────────────────────────────────────────
func _secao_botoes(vbox: VBoxContainer) -> void:
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 40)
	vbox.add_child(hbox)

	# Botão Voltar (Menu Principal)
	var btn_voltar_col = VBoxContainer.new()
	btn_voltar_col.add_theme_constant_override("separation", 6)
	hbox.add_child(btn_voltar_col)

	var btn_voltar = TextureButton.new()
	btn_voltar.texture_normal = load("res://assets/icone_voltar.png")
	btn_voltar.ignore_texture_size = true
	btn_voltar.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn_voltar.custom_minimum_size = Vector2(80, 80)
	btn_voltar.pressed.connect(_on_menu_principal_pressed)
	btn_voltar_col.add_child(btn_voltar)

	var lbl_voltar = Label.new()
	lbl_voltar.text = "Menu Principal"
	lbl_voltar.add_theme_font_size_override("font_size", 16)
	lbl_voltar.add_theme_color_override("font_color", COR_TEXTO_ESC)
	lbl_voltar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn_voltar_col.add_child(lbl_voltar)

	# Botão Sair
	var btn_sair_col = VBoxContainer.new()
	btn_sair_col.add_theme_constant_override("separation", 6)
	hbox.add_child(btn_sair_col)

	var btn_sair = TextureButton.new()
	btn_sair.texture_normal = load("res://assets/textures/exit_button.png")
	btn_sair.ignore_texture_size = true
	btn_sair.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn_sair.custom_minimum_size = Vector2(80, 80)
	btn_sair.pressed.connect(_on_sair_pressed)
	btn_sair_col.add_child(btn_sair)

	var lbl_sair = Label.new()
	lbl_sair.text = "Sair do Jogo"
	lbl_sair.add_theme_font_size_override("font_size", 16)
	lbl_sair.add_theme_color_override("font_color", COR_TEXTO_ESC)
	lbl_sair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn_sair_col.add_child(lbl_sair)

# ─── SEPARADOR ────────────────────────────────────────────────────────────────
func _sep() -> HSeparator:
	return HSeparator.new()

# ─── CALLBACKS ────────────────────────────────────────────────────────────────
func _on_menu_principal_pressed() -> void:
	if has_node("/root/GerenciadorAudio"):
		GerenciadorAudio.tocar("voltar")
	if has_node("/root/GerenciadorRanking"):
		GerenciadorRanking.resetar()
	get_tree().change_scene_to_file("res://scenes/orquestrer.tscn")

func _on_sair_pressed() -> void:
	if has_node("/root/GerenciadorAudio"):
		GerenciadorAudio.tocar("sair")
	await get_tree().create_timer(0.4).timeout
	get_tree().quit()
