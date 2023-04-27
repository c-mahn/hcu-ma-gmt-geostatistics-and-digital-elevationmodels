gmt begin BalticSea jpg

# --- setting defaults ---
gmt gmtset PROJ_ELLIPSOID WGS-84
gmt gmtset FORMAT_GEO_MAP ddd.x

# --- execute GMT commands ---

echo Map is created ...
gmt basemap -JM7.5/17 -R9:20/10:40/54:10/55:10 -B+t"Baltic Sea" -Xc -Yc -Vw
gmt coast -Bxa1g1 -Bxa1g1 -Bya0.5g0.5 -Df -W1p,120/120/120 -S160/250/250 -G160/220/160 -Ia/2p,0/0/255 -N1/1p,255/127/0 -Vw

echo Points, Labels, Lines are inserted:
gmt plot ./data/track.xy -W1p,red -Vw
gmt plot ./data/Baltic_Sea-cities.txt -Sc7p -Gwhite -W1p,black -Vw
gmt text ./data/Baltic_Sea-cities.txt -F+f+a+j -Dj3p/4p -Vw

gmt end
