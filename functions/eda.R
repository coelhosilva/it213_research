library(tidyverse)
library(arrow)

#teste pavao
# segundo teste

# Loading data
matriz_od_aerea <-
  read_parquet("./data/bd_tele_processed/matriz_od_aerea.gz.parquet")
matriz_od_nao_aerea <-
  read_parquet("./data/bd_tele_processed/matriz_od_nao_aerea.gz.parquet")
aeroportos <-
  read_parquet("./data/bd_tele_processed/aeroportos.gz.parquet")
cidades <- read_parquet("./data/bd_tele_processed/cidades.gz.parquet")

# teste <-
#   matriz_od_nao_aerea %>% group_by(idUTPorigemunicipio, idUTPdestinounicipio) %>% summarize(viagensTotais = sum(quantidadeviagem))
destinos <-
  matriz_od_nao_aerea %>% group_by(UTPdestinounicipio) %>% summarize(viagensTotais = sum(quantidadeviagem))
origens <-
  matriz_od_nao_aerea %>% group_by(UTPorigemunicipio) %>% summarize(viagensTotais = sum(quantidadeviagem))

# ggplot das top 10 origens
ggplot(origens %>% top_n(10), aes(x = UTPorigemunicipio, y = viagensTotais)) +
  geom_col() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# ggplot dos top 10 destinos
ggplot(destinos %>% top_n(10), aes(x = UTPdestinounicipio, y = viagensTotais)) +
  geom_col() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# ideias
# avaliar a demanda de viagens aéreas para criação de novas rotas ou construção de novos aeroportos.
