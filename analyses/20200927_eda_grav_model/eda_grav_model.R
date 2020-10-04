# EDA (Exploratory Data Analysis) - Modelo Gravitacional
#
# Boas referências:
# - Dr Ds Idiots Guide to Spatial Interaction Modelling for Dummies - Part 1: 
#   The Unconstrained (Total Constrained) Model by Adam Dennett available here https://rpubs.com/adam_dennett/257231
#
# - Dr Ds Idiots Guide to Spatial Interaction Modelling for Dummies - Part 2: 
#   Constrained Models by Adam Dennett available here https://rpubs.com/adam_dennett/259068
#

# Bibliotecas
library(geobr)
library(arrow)
library(ggplot2)
library(dplyr)
library(sf)
library(stplanr)
library(tidyr)

#################################
# Importação dos dados
#################################
matriz_od_aerea <- read_parquet("./data/bd_tele_processed/matriz_od_aerea.gz.parquet") # matriz aérea processada em parquet
cidades <- read_parquet("./data/bd_tele_processed/cidades.gz.parquet") # cidades processada em parquet
cidades_geobr <- readRDS("./data/extra/cidades_geobr.rds") # Dados das cidades Brasileiras previamente capturados com o geobr (vide grab_cities_geobr.R)

#################################
# Tratamento dos dados
#################################
# Filtrando os dados para apenas o estado de SP
matriz_od_aerea <- matriz_od_aerea %>% filter(UFUTPorigemunicipio=='SP',UFUTPdestinounicipio=="SP")
cidades <- cidades %>% filter(uf=="SP")
cidades_geobr <- cidades_geobr %>% filter(abbrev_state=="SP")

# Unificando os dataframes de cidades, visando adicionar a geometria para o mapa
cidades$codigo <- as.numeric(as.character(cidades$codigo))
cidades_geobr$code_muni <- as.numeric(as.character(cidades_geobr$code_muni))
cidades_joined <-left_join(cidades, cidades_geobr, by = c("codigo" = "code_muni"))

matriz_od_aerea$code_origem <- cidades_joined$codigo[match(matriz_od_aerea$idmunicipioorigem, cidades_joined$idMunicipio)]
matriz_od_aerea$code_destino <- cidades_joined$codigo[match(matriz_od_aerea$idmunicipiodestino, cidades_joined$idMunicipio)]

# calculo das viagens totais por origem-destino
matriz_od_aerea_summarized <- matriz_od_aerea %>%
  group_by(code_origem,code_destino) %>%
  summarize(
    viagensTotais = sum(quantidadeviagem)
  ) %>% 
  drop_na() #drop NA a ser corrigido. Algumas viagens de MG estavam aparecendo (aeroporto de Uberlândia)

# Filtrando para apenas as maiores viagens (mais de 150)
matriz_od_aerea_summarized <- matriz_od_aerea_summarized %>%
  filter(viagensTotais >= 150)

# Criação da rede de viagens com a função od2line
travel_network <- od2line(flow = matriz_od_aerea_summarized, zones = cidades_geobr)


#################################
# Plot das rotas no mapa de SP  
#################################
# Captura dos dados para o mapa de SP com o pacote geobr
all_muni_sp <- read_municipality(code_muni = "SP", year= 2019)

no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())

ggplot() +
  geom_sf(data=all_muni_sp, fill="#F5F5F5", color="#CCCCCC", size=.15, show.legend = FALSE) +
  geom_sf(data = travel_network$geometry, color=alpha("#8BBDD9", 0.4)) +
  labs(subtitle="Viagens no estado de São Paulo", size=8) +
  theme_minimal() +
  no_axis

###########################################
# Criação do modelo gravitacional das viagens
###########################################
# Preciso da distância entre os locais
matriz_od_aerea_summarized$geom_origem <- cidades_joined$geom[match(matriz_od_aerea_summarized$code_origem, cidades_joined$codigo)]
matriz_od_aerea_summarized$geom_destino <- cidades_joined$geom[match(matriz_od_aerea_summarized$code_destino, cidades_joined$codigo)]
matriz_od_aerea_summarized$centroid_origem <- st_centroid(matriz_od_aerea_summarized$geom_origem)
matriz_od_aerea_summarized$centroid_destino <- st_centroid(matriz_od_aerea_summarized$geom_destino)
# matriz_od_aerea_summarized$distances <- st_distance(matriz_od_aerea_summarized$centroid_origem, matriz_od_aerea_summarized$centroid_destino)
# matriz_od_aerea_summarized$distancias_m <- as.numeric(matriz_od_aerea_summarized$distances)
# matriz_od_aerea_summarized$distancias_m <- matriz_od_aerea_summarized$distances[1:nrow(matriz_od_aerea_summarized)]
# plot1 <- qplot(matriz_od_aerea_summarized$distancias_m, matriz_od_aerea_summarized$viagensTotais)
# plot1 + stat_function(fun=function(x)x^-2, geom="line", aes(colour="^-2"))


calculate_distances <- function(input_od) {
  dimData <- nrow(input_od)
  output <- c()
  for (i in 1:dimData) {
    output <- append(output, as.numeric(st_distance(input_od$centroid_origem[i], input_od$centroid_destino[i])))
  }
  return(output)
}

whattever <- function(x) {
  return(x^-2)
}
x <- c(matriz_od_aerea_summarized$distance)
y <- c(matriz_od_aerea_summarized$viagensTotais)

qplot(data.frame(x=x, y)) +
  stat_function(fun=whattever, geom="line")

# base <- ggplot()
base <- qplot(matriz_od_aerea_summarized$distance, matriz_od_aerea_summarized$viagensTotais)
base + stat_function(data=data.frame(y), fun = whattever, geom="line", aes(colour="^-2"))