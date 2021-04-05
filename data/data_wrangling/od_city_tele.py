"""Baseline origin-destination matrix (air)."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path

##############################################################################
# IMPORTING THE DATA
##############################################################################
"""
Data title: Origin-destination matrix (air).
Data source: 
    Coordenação-Geral de Planejamento, Pesquisas e Estudos da Aviação Civil.
    “Matriz de Origem/Destino real de deslocamentos de pessoas elaborada a 
    partir de Big Data da telefonia móvel.” Departamento de Planejamento e 
    Gestão da Secretaria Nacional de Aviação Civil, September 2020. 
    https://horus.labtrans.ufsc.br/gerencial/#MatrizOd.
Data year: 2017.
Data description:
    Origin-destination matrix for air transport.
"""


HOME = Path(__file__).parent.parent
DATA_PATH = (HOME / "./data_raw/BD_TELE/Matriz_OD_AEREA.csv").resolve()


df = pd.read_csv(DATA_PATH, sep=',', index_col=0)

RENAMING_DICT = {
    'tag': 'tag',
    'mes': 'month',
    'modotransporte': 'transport_mode',
    'idmunicipioorigem': 'city_origin_id',
    'municipioorigem': 'city_origin',
    'idUTPorigemunicipio': 'city_origin_utp_id',
    'UTPorigemunicipio': 'city_origin_utp',
    'UFUTPorigemunicipio': 'city_origin_utp_uf',
    'idaerodromoembarque': 'airport_origin_id',
    'aerodromoembarque': 'airport_origin_code',
    'idaerodromodesembarque': 'airport_destination_id',
    'aerodromodesembarque': 'airport_destination_code',
    'UFUTPdestinounicipio': 'city_destination_utp_uf',
    'idUTPdestinounicipio': 'city_destination_utp_id',
    'UTPdestinounicipio': 'city_destination_utp',
    'idmunicipiodestino': 'city_destination_id',
    'municipiodestino': 'city_destination',
    'quantidadeviagem': 'total_pax'
    }

df = df.rename(columns=RENAMING_DICT)

df_od = df[
    ['city_origin_id',
     'city_destination_id',
     'total_pax']
    ].groupby(
        ['city_origin_id',
         'city_destination_id']
        ).sum().reset_index()

