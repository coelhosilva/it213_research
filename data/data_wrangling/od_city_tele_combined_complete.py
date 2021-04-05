"""Joining the OD matrix with geo-economic data."""
##############################################################################
# LIBS
##############################################################################
try:
    from geopy.distance import great_circle
    from .db_data_city import df as city_tele_db
    from .od_city_tele import df_od
    from .db_city_geo import df as city_geo_db
    from .ibge_data_pop import df as df_pop
    from .ibge_data_gdp import df as df_gdp
    from .ibge_ipea_data_econ import df as df_geo_econ
except:
    from geopy.distance import great_circle
    from db_data_city import df as city_tele_db
    from od_city_tele import df_od
    from db_city_geo import df as city_geo_db
    from ibge_data_pop import df as df_pop
    from ibge_data_gdp import df as df_gdp
    from ibge_ipea_data_econ import df as df_geo_econ
##############################################################################
# IMPORTING THE DATA
##############################################################################
"""
Data title: Origin-destination matrix (air).
Data source: 
    [1] Coordenação-Geral de Planejamento, Pesquisas e Estudos da Aviação Civil.
    “Matriz de Origem/Destino real de deslocamentos de pessoas elaborada a 
    partir de Big Data da telefonia móvel.” Departamento de Planejamento e 
    Gestão da Secretaria Nacional de Aviação Civil, September 2020. 
    https://horus.labtrans.ufsc.br/gerencial/#MatrizOd.
    
    [2] Instituto de Pesquisa Econômica Aplicada. 
    “Atlas do Desenvolvimento Humano.”
    Instituto de Pesquisa Econômica Aplicada, 2020.
    http://www.atlasbrasil.org.br/acervo/biblioteca.
    
    [3] OpenStreetMap.
Data year: 2010, 2017, and 2021.
Data description:
    Origin-destination matrix for air transport, coupled with geo-economic
    indicators.
"""


df_pop = df_pop.set_index('ibge_code')
dict_pop = df_pop['pop'].to_dict()

city_tele_db = city_tele_db.set_index('city_id')
dict_city_name = city_tele_db['city_name'].to_dict()
dict_ibge_code = city_tele_db['ibge_code'].to_dict()

city_geo_db = city_geo_db.set_index('ibge_code')
dict_latitude = city_geo_db['latitude'].to_dict()
dict_longitude = city_geo_db['longitude'].to_dict()

df_gdp = df_gdp.set_index('ibge_code')
dict_gdp = df_gdp['gdp_per_capita'].to_dict()

ECONOMIC_VARS = ['ESPVIDA',
       'FECTOT', 'MORT1', 'MORT5', 'RAZDEP', 'SOBRE40', 'SOBRE60',
       'T_ENV', 'E_ANOSESTUDO', 'T_ANALF11A14', 'T_ANALF15A17',
       'T_ANALF15M', 'T_ANALF18A24', 'T_ANALF18M', 'T_ANALF25A29',
       'T_ANALF25M', 'T_ATRASO_0_BASICO', 'T_ATRASO_0_FUND',
       'T_ATRASO_0_MED', 'T_ATRASO_1_BASICO', 'T_ATRASO_1_FUND',
       'T_ATRASO_1_MED', 'T_ATRASO_2_BASICO', 'T_ATRASO_2_FUND',
       'T_ATRASO_2_MED', 'T_FBBAS', 'T_FBFUND', 'T_FBMED', 'T_FBPRE',
       'T_FBSUPER', 'T_FLBAS', 'T_FLFUND', 'T_FLMED', 'T_FLPRE',
       'T_FLSUPER', 'T_FREQ0A3', 'T_FREQ11A14', 'T_FREQ15A17',
       'T_FREQ18A24', 'T_FREQ25A29', 'T_FREQ4A5', 'T_FREQ4A6',
       'T_FREQ5A6', 'T_FREQ6', 'T_FREQ6A14', 'T_FREQ6A17',
       'T_FREQFUND1517', 'T_FREQFUND1824', 'T_FREQFUND45',
       'T_FREQMED1824', 'T_FREQMED614', 'T_FREQSUPER1517', 'T_FUND11A13',
       'T_FUND12A14', 'T_FUND15A17', 'T_FUND16A18', 'T_FUND18A24',
       'T_FUND18M', 'T_FUND25M', 'T_MED18A20', 'T_MED18A24', 'T_MED18M',
       'T_MED19A21', 'T_MED25M', 'T_SUPER25M', 'CORTE1', 'CORTE2',
       'CORTE3', 'CORTE4', 'CORTE9', 'GINI', 'PIND', 'PINDCRI', 'PMPOB',
       'PMPOBCRI', 'PPOB', 'PPOBCRI', 'PREN10RICOS', 'PREN20',
       'PREN20RICOS', 'PREN40', 'PREN60', 'PREN80', 'PRENTRAB', 'R1040',
       'R2040', 'RDPC', 'RDPC1', 'RDPC10', 'RDPC2', 'RDPC3', 'RDPC4',
       'RDPC5', 'RDPCT', 'RIND', 'RMPOB', 'RPOB', 'THEIL', 'CPR', 'EMP',
       'P_AGRO', 'P_COM', 'P_CONSTR', 'P_EXTR', 'P_FORMAL', 'P_FUND',
       'P_MED', 'P_SERV', 'P_SIUP', 'P_SUPER', 'P_TRANSF', 'REN0', 'REN1',
       'REN2', 'REN3', 'REN5', 'RENOCUP', 'T_ATIV', 'T_ATIV1014',
       'T_ATIV1517', 'T_ATIV1824', 'T_ATIV18M', 'T_ATIV2529', 'T_DES',
       'T_DES1014', 'T_DES1517', 'T_DES1824', 'T_DES18M', 'T_DES2529',
       'THEILtrab', 'TRABCC', 'TRABPUB', 'TRABSC', 'T_AGUA', 'T_BANAGUA',
       'T_DENS', 'T_LIXO', 'T_LUZ', 'AGUA_ESGOTO', 'PAREDE',
       'T_CRIFUNDIN_TODOS', 'T_FORA4A5', 'T_FORA6A14', 'T_FUNDIN_TODOS',
       'T_FUNDIN_TODOS_MMEIO', 'T_FUNDIN18MINF', 'T_M10A14CF',
       'T_M15A17CF', 'T_MULCHEFEFIF014', 'T_NESTUDA_NTRAB_MMEIO',
       'T_OCUPDESLOC_1', 'T_RMAXIDOSO', 'T_SLUZ', 'HOMEM0A4',
       'HOMEM10A14', 'HOMEM15A19', 'HOMEM20A24', 'HOMEM25A29',
       'HOMEM30A34', 'HOMEM35A39', 'HOMEM40A44', 'HOMEM45A49',
       'HOMEM50A54', 'HOMEM55A59', 'HOMEM5A9', 'HOMEM60A64', 'HOMEM65A69',
       'HOMEM70A74', 'HOMEM75A79', 'HOMEMTOT', 'HOMENS80', 'MULH0A4',
       'MULH10A14', 'MULH15A19', 'MULH20A24', 'MULH25A29', 'MULH30A34',
       'MULH35A39', 'MULH40A44', 'MULH45A49', 'MULH50A54', 'MULH55A59',
       'MULH5A9', 'MULH60A64', 'MULH65A69', 'MULH70A74', 'MULH75A79',
       'MULHER80', 'MULHERTOT', 'PEA', 'PEA1014', 'PEA1517', 'PEA18M',
       'peso1', 'PESO1114', 'PESO1113', 'PESO1214', 'peso13', 'PESO15',
       'peso1517', 'PESO1524', 'PESO1618', 'PESO18', 'Peso1820',
       'PESO1824', 'Peso1921', 'PESO25', 'peso4', 'peso5', 'peso6',
       'PESO610', 'Peso617', 'PESO65', 'PESOM1014', 'PESOM1517',
       'PESOM15M', 'PESOM25M', 'pesoRUR', 'pesotot', 'pesourb', 'PIA',
       'PIA1014', 'PIA1517', 'PIA18M', 'POP', 'POPT', 'I_ESCOLARIDADE',
       'I_FREQ_PROP', 'IDHM', 'IDHM_E', 'IDHM_L', 'IDHM_R']

df_geo_econ = df_geo_econ[['year', 'ibge_code', 'city_name']+ECONOMIC_VARS]
df_geo_econ = df_geo_econ.set_index('ibge_code')

df_od['city_origin'] = df_od['city_origin_id'].map(dict_city_name)
df_od['city_destination'] = df_od['city_destination_id'].map(dict_city_name)
df_od['ibge_code_origin'] = df_od['city_origin_id'].map(dict_ibge_code)
df_od['ibge_code_destination'] = df_od['city_destination_id'].map(dict_ibge_code)

df_od['latitude_origin'] = df_od['ibge_code_origin'].map(dict_latitude)
df_od['longitude_origin'] = df_od['ibge_code_origin'].map(dict_longitude)
df_od['latitude_destination'] = df_od['ibge_code_destination'].map(dict_latitude)
df_od['longitude_destination'] = df_od['ibge_code_destination'].map(dict_longitude)
df_od['distance_km'] = df_od.apply(lambda x: great_circle((x['latitude_origin'], x['longitude_origin']), (x['latitude_destination'], x['longitude_destination'])).kilometers, axis=1)

df_od['population_origin'] = df_od['ibge_code_origin'].map(dict_pop)
df_od['population_destination'] = df_od['ibge_code_destination'].map(dict_pop)

# Economic data
# GDP per capita
df_od['gdp_per_capita_origin'] = df_od['ibge_code_origin'].map(dict_gdp)
df_od['gdp_per_capita_destination'] = df_od['ibge_code_destination'].map(dict_gdp)

# Geoeconomic
for var in ECONOMIC_VARS:
    dict_var = df_geo_econ[var].to_dict()
    df_od['{}_origin'.format(var)] = df_od['ibge_code_origin'].map(dict_var)
    df_od['{}_destination'.format(var)] = df_od['ibge_code_destination'].map(dict_var)
    del dict_var
