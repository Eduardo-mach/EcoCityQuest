extends Control
# Script único para todos os rankings intermediários.
# Detecta qual jogo foi concluído pelo caminho da cena atual.

const COR_BOTAO       = Color(0.547, 0.698, 0.082, 1.0) 

# Cores de Estrutura e Interface (A cor da luz nos painéis)
const COR_PAINEL     = Color(0.12, 0.10, 0.08, 1.0) # Sombra da noite (um marrom-grafite bem escuro e quente, onde a luz do poste não bate)
const COR_FUNDO    = Color(0.93, 0.67, 0.12, 1.0) # Luz do Poste Antigo pura (Vapor de Sódio) - Seus painéis e menus vão brilhar nessa cor!
const COR_TEXTO_ESC = Color(0.98, 0.95, 0.90)      # Marrom asfalto profundo (para escrever com contraste perfeito EM CIMA do painel amarelo)
const COR_TEXTO_CLA = Color(0.98, 0.95, 0.90)      # Branco incandescente suave (para usar sobre o fundo escuro)

# Cores de Ranking / Medalhas (Tons que combinam com a iluminação quente)
const COR_OURO      = Color(1.00, 0.50, 0.00)      # Laranja vivo (para destacar do painel amarelo)
const COR_PRATA     = Color(0.45, 0.47, 0.50)      # Cinza chumbo/sombra
const COR_BRONZE    = Color(0.65, 0.35, 0.15)      # Marrom acobreado queimado
const COR_NORMAL    = Color(0.30, 0.26, 0.22)      # Sombra neutra

# Cores de Feedback / Botões (Ajustadas para não sumirem no fundo amarelo)
const COR_BOTAO_VRD = Color(0.547, 0.698, 0.082, 1.0)      # Verde garrafa escuro (alta leitura sobre o amarelo)
const COR_BOTAO_VRM = Color(0.65, 0.12, 0.12)    

var label_pontos_jogador: Label
var vbox_ranking: VBoxContainer

func _ready() -> void:
	var config = _detectar_config()
	_construir_ui(config["titulo"])
	_popular_dados(config["chave"])

# ─── DETECTA QUAL RANKING MOSTRAR COM BASE NO CAMINHO DA CENA ────────────────
func _detectar_config() -> Dictionary:
	var caminho = scene_file_path  # caminho do .tscn desta instância
	match caminho:
		"res://Fase1/ranking_memoria.tscn":
			return {"titulo": "JOGO DA MEMÓRIA",  "chave": "pontos_memoria"}
		"res://Fase1/ranking_telhado.tscn":
			return {"titulo": "JOGO DO TELHADO",  "chave": "pontos_telhado"}
		"res://Fase2/ranking_rua.tscn":
			return {"titulo": "CONSERTE A RUA",   "chave": "pontos_rua"}
		"res://Fase2/ranking_cacapalavras.tscn":
			return {"titulo": "CAÇA-PALAVRAS",    "chave": "pontos_caca_palavras"}
	# fallback
	return {"titulo": "RANKING", "chave": "pontos_memoria"}

# ─── CONSTRUÇÃO DA UI ────────────────────────────────────────────────────────
func _construir_ui(titulo_jogo: String) -> void:
	var fundo = ColorRect.new()
	fundo.color = COR_FUNDO
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(fundo)

	var painel_rect = ColorRect.new()
	painel_rect.color = COR_PAINEL
	painel_rect.layout_mode = 1
	painel_rect.anchor_left   = 0.08
	painel_rect.anchor_top    = 0.08
	painel_rect.anchor_right  = 0.92
	painel_rect.anchor_bottom = 0.92
	add_child(painel_rect)

	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox_main = VBoxContainer.new()
	vbox_main.add_theme_constant_override("separation", 12)
	vbox_main.custom_minimum_size = Vector2(700, 0)
	center.add_child(vbox_main)

	# Troféu
	var trofeu = Label.new()
	trofeu.text = "🏆"
	trofeu.add_theme_font_size_override("font_size", 72)
	trofeu.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox_main.add_child(trofeu)

	# Título do jogo
	var lbl_titulo = Label.new()
	lbl_titulo.text = titulo_jogo
	lbl_titulo.add_theme_font_size_override("font_size", 38)
	lbl_titulo.add_theme_color_override("font_color", COR_TEXTO_ESC)
	lbl_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox_main.add_child(lbl_titulo)

	vbox_main.add_child(HSeparator.new())

	# Pontuação do jogador
	var hbox_jogador = HBoxContainer.new()
	hbox_jogador.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox_main.add_child(hbox_jogador)

	var lbl_sua = Label.new()
	lbl_sua.text = "Sua pontuação:  "
	lbl_sua.add_theme_font_size_override("font_size", 30)
	lbl_sua.add_theme_color_override("font_color", COR_TEXTO_ESC)
	hbox_jogador.add_child(lbl_sua)

	label_pontos_jogador = Label.new()
	label_pontos_jogador.text = "---"
	label_pontos_jogador.add_theme_font_size_override("font_size", 36)
	label_pontos_jogador.add_theme_color_override("font_color", COR_BOTAO)
	hbox_jogador.add_child(label_pontos_jogador)

	vbox_main.add_child(HSeparator.new())

	# Título top 3
	var lbl_rank_titulo = Label.new()
	lbl_rank_titulo.text = "TOP 3 – Ranking Geral"
	lbl_rank_titulo.add_theme_font_size_override("font_size", 26)
	lbl_rank_titulo.add_theme_color_override("font_color", COR_TEXTO_ESC)
	lbl_rank_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox_main.add_child(lbl_rank_titulo)

	vbox_ranking = VBoxContainer.new()
	vbox_ranking.add_theme_constant_override("separation", 8)
	vbox_main.add_child(vbox_ranking)

	vbox_main.add_child(HSeparator.new())

	# Botão Próximo
	var botao = Button.new()
	botao.text = "▶  Próximo Jogo"
	botao.add_theme_font_size_override("font_size", 28)
	botao.custom_minimum_size = Vector2(280, 60)
	botao.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var estilo = StyleBoxFlat.new()
	estilo.bg_color = COR_BOTAO
	estilo.set_corner_radius_all(12)
	estilo.content_margin_left = 20
	estilo.content_margin_right = 20
	botao.add_theme_stylebox_override("normal", estilo)
	botao.add_theme_color_override("font_color", Color(1, 1, 1))
	botao.pressed.connect(_on_proximo_pressed)
	vbox_main.add_child(botao)

# ─── POPULAR DADOS ───────────────────────────────────────────────────────────
func _popular_dados(chave_pontuacao: String) -> void:
	# Pontuação da sessão atual neste jogo
	var pontos_jogo = 0
	if has_node("/root/GerenciadorRanking"):
		var val = GerenciadorRanking.get(chave_pontuacao)
		pontos_jogo = val if val != null else 0
	label_pontos_jogador.text = str(pontos_jogo) + " pts"

	# Top 3 histórico
	var ranking: Array = []
	if has_node("/root/GerenciadorJogo"):
		ranking = GerenciadorJogo.ranking

	var medalhas = ["🥇", "🥈", "🥉"]
	var cores    = [COR_OURO, COR_PRATA, COR_BRONZE]

	for i in range(min(3, ranking.size())):
		var entrada = ranking[i]
		var linha = HBoxContainer.new()
		linha.add_theme_constant_override("separation", 12)

		var lbl_med = Label.new()
		lbl_med.text = medalhas[i]
		lbl_med.add_theme_font_size_override("font_size", 50)
		lbl_med.custom_minimum_size = Vector2(40, 0)
		linha.add_child(lbl_med)

		var lbl_nome = Label.new()
		lbl_nome.text = str(entrada.get("nome", "?"))
		lbl_nome.add_theme_font_size_override("font_size", 24)
		lbl_nome.add_theme_color_override("font_color", cores[i])
		lbl_nome.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		linha.add_child(lbl_nome)

		var lbl_pts = Label.new()
		lbl_pts.text = str(entrada.get("pontuacao", 0)) + " pts"
		lbl_pts.add_theme_font_size_override("font_size", 24)
		lbl_pts.add_theme_color_override("font_color", COR_TEXTO_ESC)
		linha.add_child(lbl_pts)

		vbox_ranking.add_child(linha)

	if ranking.is_empty():
		var lbl_vazio = Label.new()
		lbl_vazio.text = "Seja o primeiro no ranking!"
		lbl_vazio.add_theme_color_override("font_color", COR_TEXTO_ESC)
		lbl_vazio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox_ranking.add_child(lbl_vazio)

# ─── AVANÇAR ────────────────────────────────────────────────────────────────
func _on_proximo_pressed() -> void:
	if has_node("/root/GerenciadorAudio"):
		GerenciadorAudio.tocar("avancar")
	if has_node("/root/GerenciadorJogo"):
		GerenciadorJogo.avancar_exercicio()
