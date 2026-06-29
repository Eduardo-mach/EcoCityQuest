extends Node

# Dados do jogador atual
var nome_jogador: String = ""
var indice_cena_atual: int = -1

# Estrutura para o Ranking Geral (histórico persistido)
var ranking: Array = []
const CAMINHO_SALVAMENTO = "user://ranking_ecocity.json"

# ─── SEQUÊNCIA COMPLETA DO JOGO ───────────────────────────────────────────────
# Cada jogo é seguido de uma tela de ranking intermediária
var ordem_cenas: Array = [
	"res://Fase1/JogoMemoria/Exercicio1/JogoMemoria.tscn",  # 0 – Jogo da Memória
	"res://Fase1/ranking_memoria.tscn",                      # 1 – Ranking Memória
	"res://Fase1/JogoTelhado/Exercicio2/JogoTelhado.tscn",  # 2 – Jogo do Telhado
	"res://Fase1/ranking_telhado.tscn",                      # 3 – Ranking Telhado
	"res://Fase2/Exercicio1/tela_caca_palavras.tscn",       # 4 – Caça-Palavras
	"res://Fase2/ranking_cacapalavras.tscn",                 # 5 – Ranking Caça-Palavras
	"res://Fase2/Exercicio2/conserte_a_rua_tscn.tscn",      # 6 – Conserte a Rua
	"res://Fase2/ranking_rua.tscn",                          # 7 – Ranking Rua
	"res://scenes/ranking_geral.tscn",                       # 8 – Ranking Geral Final
]

# Narração a tocar quando cada JOGO começa (apenas jogos, não rankings)
var audio_por_indice: Dictionary = {
	0: "fase1_ex1",
	2: "fase1_ex2",
	4: "fase2_ex1",   # Caça-Palavras é o Ex1 da Fase 2
	6: "fase2_ex2",   # Conserte a Rua é o Ex2 da Fase 2
}

func _ready():
	carregar_ranking()

# ─── INICIAR NOVO JOGO ────────────────────────────────────────────────────────
func iniciar_novo_jogo(nome: String):
	nome_jogador = nome.strip_edges()
	if nome_jogador == "":
		nome_jogador = "Jogador"
	indice_cena_atual = 0
	print("[GerenciadorJogo] Novo jogo iniciado para: ", nome_jogador)
	# Toca som de JOGAR e em seguida navega para o primeiro jogo
	GerenciadorAudio.tocar("jogar")
	_navegar_para_cena(indice_cena_atual)

# ─── AVANÇAR EXERCÍCIO ────────────────────────────────────────────────────────
# Chamado pelos jogos quando terminam (sucesso ou tempo esgotado)
func avancar_exercicio():
	indice_cena_atual += 1
	if indice_cena_atual < ordem_cenas.size():
		_navegar_para_cena(indice_cena_atual)
	else:
		print("[GerenciadorJogo] Todas as fases concluídas!")
		get_tree().change_scene_to_file("res://scenes/ranking_geral.tscn")

# ─── NAVEGAR PARA CENA ────────────────────────────────────────────────────────
func _navegar_para_cena(indice: int):
	if indice < 0 or indice >= ordem_cenas.size():
		return
	var cena = ordem_cenas[indice]
	# Interrompe qualquer narração em andamento antes de trocar de cena
	GerenciadorAudio.parar_narracao()
	# Toca a narração da próxima cena (se for um jogo, não um ranking)
	if audio_por_indice.has(indice):
		GerenciadorAudio.tocar(audio_por_indice[indice])
	print("[GerenciadorJogo] Indo para: ", cena)
	get_tree().change_scene_to_file(cena)

# ─── FINALIZAR JOGO (salva pontuação total no ranking histórico) ──────────────
func finalizar_jogo(pontuacao_total: int):
	var nome_salvar = nome_jogador if nome_jogador != "" else "Jogador"

	var nova_entrada = {
		"nome": nome_salvar,
		"pontuacao": pontuacao_total
	}

	ranking.append(nova_entrada)

	# Ordena do maior para o menor
	for i in range(ranking.size()):
		for j in range(i + 1, ranking.size()):
			if int(ranking[j]["pontuacao"]) > int(ranking[i]["pontuacao"]):
				var temp = ranking[i]
				ranking[i] = ranking[j]
				ranking[j] = temp

	# Mantém apenas top 5
	if ranking.size() > 5:
		ranking.resize(5)

	salvar_ranking()
	print("[GerenciadorJogo] Pontuação final salva: ", nome_salvar, " → ", pontuacao_total)

# ─── PERSISTÊNCIA ─────────────────────────────────────────────────────────────
func salvar_ranking():
	var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.WRITE)
	if arquivo:
		arquivo.store_string(JSON.stringify(ranking))
		arquivo.close()

func carregar_ranking():
	if FileAccess.file_exists(CAMINHO_SALVAMENTO):
		var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.READ)
		if arquivo:
			var conteudo = arquivo.get_as_text()
			arquivo.close()
			var json = JSON.new()
			if json.parse(conteudo) == OK:
				var dados = json.get_data()
				if dados is Array:
					ranking = dados
