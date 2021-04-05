"""Airport database."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path

##############################################################################
# IMPORTING THE DATA
##############################################################################
"""
Data title: Airports list.
Data source: 
    Coordenação-Geral de Planejamento, Pesquisas e Estudos da Aviação Civil.
    “Matriz de Origem/Destino real de deslocamentos de pessoas elaborada a 
    partir de Big Data da telefonia móvel.” Departamento de Planejamento e 
    Gestão da Secretaria Nacional de Aviação Civil, September 2020. 
    https://horus.labtrans.ufsc.br/gerencial/#MatrizOd.
Data year: 2017.
Data description:
    Accompanying airport database, related to the OD matrix.
"""

HOME = Path(__file__).parent.parent
DATA_PATH = (HOME / "./data_raw/BD_TELE/Lista de aeroportos.xlsx").resolve()

df = pd.read_excel(DATA_PATH)

RENAMING_DICT = {
    'ICAO': 'icao',
    'NOME DO AEROPORTO': 'airport_name',
    'LATITUDE DEC': 'latitude_dec',
    'LONGITUDE DEC': 'longitude_dec',
    'Código IBGE': 'ibge_code',
    'UF': 'uf',
    'REGIÃO': 'region',
    'UTP': 'utp_id',
    }

df = df.rename(columns=RENAMING_DICT)

# Dealing with exceptions
df.loc[df.icao=='SBBR', 'utp_id'] = 787
