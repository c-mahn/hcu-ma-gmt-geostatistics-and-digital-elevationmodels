gmt begin BalticSea jpg

# --- setting defaults ---
gmt gmtset PROJ_ELLIPSOID WGS-84
gmt gmtset FORMAT_GEO_MAP ddd.x

# --- execute GMT commands ---

echo Map is created ...
gmt basemap -JM10/17 -R9:20/10:40/54:10/55:10 -B+t"Baltic Sea" -Xc -Yc -Lx8.5c/-2c+c54+w100k+f+u -V
gmt coast -Bxa0.5g0.5 -Bya0.5g0.5 -Df -W1p,120/120/120 -S153/204/255 -G204/255/153 -Ia/2p,blue -N1/1p,255/0/0,dashed -V

echo Points, Labels, Lines are inserted:
gmt plot ./data/track.xy -W1p,red -V
gmt plot ./data/Baltic_Sea-cities.txt -Sc7p -Gwhite -W1p,black -V
gmt text ./data/Baltic_Sea-cities.txt -F+f+a+j -Dj3p/4p -V

gmt end
