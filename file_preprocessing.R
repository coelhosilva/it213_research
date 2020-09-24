library(tidyverse)
library(xlsx)
library(arrow)

# Funções para carregamento dos dados
load_xlsx <- function(file_path, sheetIndex=1, encoding="UTF-8") {
  # Leitura de um xlsx.
  df <- as_tibble(read.xlsx(file_path, sheetIndex=sheetIndex, encoding=encoding))
  return(df)
}

load_airports <- function(rename_columns=FALSE) {
  # Leitura do arquivo de aeroportos.
  airports <- load_xlsx("./local/BD_TELE/Lista de aeroportos.xlsx")
  if (rename_columns) {
    airports <- airports %>% 
      rename(
        icao_code = ICAO,
        airport_name = NOME.DO.AEROPORTO,
        latitude_dec = LATITUDE.DEC,
        longitude_dec = LONGITUDE.DEC,
        ibge_code = Código.IBGE,
        state = UF,
        region = REGIÃO,
        utp_id = UTP
      )
  }
  
  return(airports)
}


load_cities <- function(rename_columns=FALSE) {
  # Leitura do arquivo de cidades.
  cities <- load_xlsx("./local/BD_TELE/Lista de municipios e UTPs.xlsx")
  if (rename_columns) {
    cities <- cities %>%
      rename(
        city_id = idMunicipio,
        code = codigo,
        name = nome,
        state = uf,
        utp_id = idUtp,
        utp = utp
      )
  }
  
  return(cities)
}


load_od_aerea <- function() {
  # Leitura do arquivo de origem-destino da matriz aérea.
  matriz_od_aerea <- as_tibble(read.delim("./local/BD_TELE/Matriz_OD_AEREA.csv", header=TRUE, sep=",", encoding="UTF-8"))
  matriz_od_aerea <- matriz_od_aerea %>%
    rename(
      tag = X.U.FEFF.tag
    )
  
  return(matriz_od_aerea)
}


load_od_nao_aerea <- function() {
  # Leitura do arquivo de origem-destino da matriz não aérea.
  matriz_od_nao_aerea <- as_tibble(read.delim("./local/BD_TELE/Matriz_OD_NAO_AEREA.csv", header=TRUE, sep=",", encoding="UTF-8"))
  matriz_od_nao_aerea <- matriz_od_nao_aerea %>%
    rename(
      tag = X.U.FEFF.tag
    )
  
  return(matriz_od_nao_aerea)
}

# Carregamento dos dados
aeroportos <- load_airports()
cidades <- load_cities()
matriz_od_aerea <- load_od_aerea()
matriz_od_nao_aerea <- load_od_nao_aerea()

# Reescrita dos dados em um formato otimizado
if (codec_is_available("gzip")) {
  write_parquet(aeroportos, "./bd_tele_processed/aeroportos.gz.parquet", compression = "gzip", compression_level = 5)
  write_parquet(cidades, "./bd_tele_processed/cidades.gz.parquet", compression = "gzip", compression_level = 5)
  write_parquet(matriz_od_aerea, "./bd_tele_processed/matriz_od_aerea.gz.parquet", compression = "gzip", compression_level = 5)
  write_parquet(matriz_od_nao_aerea, "./bd_tele_processed/matriz_od_nao_aerea.gz.parquet", compression = "gzip", compression_level = 5)
}