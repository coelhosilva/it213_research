"""IBGE data - GDP."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path

##############################################################################
# IMPORTING THE DATA
##############################################################################
"""
Data title: City GDP.
Data source: 
    Instituto de Pesquisa Econômica Aplicada. 
    “Atlas do Desenvolvimento Humano.”
    Instituto de Pesquisa Econômica Aplicada, 2020.
    http://www.atlasbrasil.org.br/acervo/biblioteca.

Data year: 2017
Data description:
    City level GDP according to the IBGE database.
"""


HOME = Path(__file__).parent.parent
DATA_PATH = (HOME / "./data_raw/ibge/PIB dos Municípios - base de dados 2010-2017.csv").resolve()

df = pd.read_csv(DATA_PATH)

RENAMING_DICT = {
    'Ano': 'year',
    # 'Código da Grande Região', 
    # 'Nome da Grande Região',
    # 'Código da Unidade da Federação', 
    # 'Sigla da Unidade da Federação',
    # 'Nome da Unidade da Federação', 
    'Código do Município': 'ibge_code',
    'Nome do Município': 'city_name',
    # 'Região Metropolitana', 
    # 'Código da Mesorregião',
    # 'Nome da Mesorregião', 
    # 'Código da Microrregião', 
    # 'Nome da Microrregião',
    # 'Código da Região Geográfica Imediata',
    # 'Nome da Região Geográfica Imediata',
    # 'Município da Região Geográfica Imediata',
    # 'Código da Região Geográfica Intermediária',
    # 'Nome da Região Geográfica Intermediária',
    # 'Município da Região Geográfica Intermediária',
    # 'Código Concentração Urbana', 
    # 'Nome Concentração Urbana',
    # 'Tipo Concentração Urbana', 
    # 'Código Arranjo Populacional',
    # 'Nome Arranjo Populacional', 
    # 'Hierarquia Urbana',
    # 'Hierarquia Urbana (principais categorias)', 
    # 'Código da Região Rural',
    # 'Nome da Região Rural',
    # 'Região rural (segundo classificação do núcleo)', 
    # 'Amazônia Legal',
    # 'Semiárido', 
    # 'Cidade-Região de São Paulo',
    # 'Valor adicionado bruto da Agropecuária, \na preços correntes\n(R$ 1.000)',
    # 'Valor adicionado bruto da Indústria,\na preços correntes\n(R$ 1.000)',
    # 'Valor adicionado bruto dos Serviços,\na preços correntes \n- exceto Administração, defesa, educação e saúde públicas e seguridade social\n(R$ 1.000)',
    # 'Valor adicionado bruto da Administração, defesa, educação e saúde públicas e seguridade social, \na preços correntes\n(R$ 1.000)',
    # 'Valor adicionado bruto total, \na preços correntes\n(R$ 1.000)',
    # 'Impostos, líquidos de subsídios, sobre produtos, \na preços correntes\n(R$ 1.000)',
    'Produto Interno Bruto, \na preços correntes\n(R$ 1.000)': 'gdp',
    'Produto Interno Bruto per capita, \na preços correntes\n(R$ 1,00)': 'gdp_per_capita',
    # 'Atividade com maior valor adicionado bruto',
    # 'Atividade com segundo maior valor adicionado bruto',
    # 'Atividade com terceiro maior valor adicionado bruto'
    }

df = df.rename(columns=RENAMING_DICT)
df = df.loc[df['year']==2017][RENAMING_DICT.values()]
