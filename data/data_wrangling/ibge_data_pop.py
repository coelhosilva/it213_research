"""IBGE data - Population."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path

##############################################################################
# IMPORTING THE DATA
##############################################################################
"""
Data title: City population.
Data source: 
    Instituto de Pesquisa Econômica Aplicada. 
    “Atlas do Desenvolvimento Humano.”
    Instituto de Pesquisa Econômica Aplicada, 2020.
    http://www.atlasbrasil.org.br/acervo/biblioteca.

Data year: 2017.
Data description:
    City level population according to IBGE database.
"""


HOME = Path(__file__).parent.parent
DATA_PATH = (HOME / "./data_raw/ibge/pop_muni_2017.xlsx").resolve()

df = pd.read_excel(DATA_PATH)
df['ibge_code'] = (df['uf_code'].astype(str) + df['ibge_code'].astype(str).str.zfill(5)).astype(int)
