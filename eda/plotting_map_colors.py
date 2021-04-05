"""Plotting the route map."""
from pathlib import Path
import cartopy.crs as ccrs
import cartopy.io.shapereader as shpreader
from data.data_wrangling.od_city_tele_combined_complete import df_od
import matplotlib.pyplot as plt
import matplotlib.colors
from matplotlib import cm

plt.style.use('ggplot')

HOME = Path(__file__)

# Map file sourced from https://gadm.org/download_country_v3.html
# Not included due to license.
MAP_FILE = (HOME / "../../local/map_shape/gadm36_BRA_1.shp").resolve()

MIN_VALUE = 1000

df_od = df_od.loc[df_od["distance_km"] > 200].loc[df_od["total_pax"] > MIN_VALUE]

country_map_shapes = list(shpreader.Reader(MAP_FILE).geometries())

ax = plt.axes(projection=ccrs.PlateCarree())

ax.add_geometries(country_map_shapes, ccrs.PlateCarree(),
                  edgecolor='black', facecolor='#F8F8F8', alpha=1)

# Color gradient
cmap = cm.get_cmap('viridis')
norm=matplotlib.colors.LogNorm(vmin=MIN_VALUE, vmax=1000000)

# Plotting each route
for index, row in df_od.sort_values(by='total_pax').iterrows():
    lats = [row.latitude_origin, row.latitude_destination]
    longs = [row.longitude_origin , row.longitude_destination]
    plt.plot(longs, lats,
              color=cmap(norm(row.total_pax)),
              linewidth=0.75,
              marker='o',
              markersize=1.25,
              alpha=0.2,
              transform=ccrs.PlateCarree(),
              )

ax.set_extent([-76, -32, -35, 7], ccrs.PlateCarree())

sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)

cbar = plt.colorbar(sm)
cbar.set_label('Number of passengers')
plt.show()
plt.savefig('route_map_hued.png',
            dpi=300,
            bbox_inches='tight',
            pad_inches = 0.1
)
plt.close()
