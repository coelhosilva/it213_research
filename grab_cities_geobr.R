library(geobr)
library(arrow)

'%!in%' <- function(x,y)!('%in%'(x,y)) # definição da função "not in"

cidades <- read_parquet("./bd_tele_processed/cidades.gz.parquet")

# check da existência da variável caso a função precise ser rodada novamente por timeout
if (!exists("output_cidades_geobr")) {
  output_cidades_geobr = data.frame()
}

for (uf in unique(cidades$uf)) {
  if (uf %!in% unique(output_cidades_geobr$abbrev_state)) {
    output_cidades_geobr <- rbind(output_cidades_geobr, read_municipality(code_muni= uf, year=2019))
  }
}

saveRDS(output_cidades_geobr, file = "cidades_geobr.rds")