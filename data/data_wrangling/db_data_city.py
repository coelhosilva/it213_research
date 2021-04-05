"""City database."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path

##############################################################################
# IMPORTING THE DATA
##############################################################################
"""
Data title: City database.
Data source: 
    Coordenação-Geral de Planejamento, Pesquisas e Estudos da Aviação Civil.
    “Matriz de Origem/Destino real de deslocamentos de pessoas elaborada a 
    partir de Big Data da telefonia móvel.” Departamento de Planejamento e 
    Gestão da Secretaria Nacional de Aviação Civil, September 2020. 
    https://horus.labtrans.ufsc.br/gerencial/#MatrizOd.
Data year: 2017.
Data description:
    Accompanying city database, related to the OD matrix.
"""


HOME = Path(__file__).parent.parent
DATA_PATH = (HOME / "./data_raw/BD_TELE/Lista de municipios e UTPs.xlsx").resolve()

df = pd.read_excel(DATA_PATH)

RENAMING_DICT = {
    'idMunicipio': 'city_id',
    'codigo': 'ibge_code',
    'nome': 'city_name',
    'uf': 'state',
    'idUtp': 'utp_id',
    'utp': 'city_origin_utp_id'
    }

df = df.rename(columns=RENAMING_DICT)
