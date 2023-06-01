echo Script written by Christopher Mahn
echo [1/5] Begin image
gmt begin output jpg

echo [2/5] Set GMT-Settings
gmt gmtset PROJ_ELLIPSOID WGS-84
gmt gmtset FORMAT_GEO_MAP ddd:mm
gmt gmtset PS_MEDIA A4
gmt gmtset MAP_FRAME_WIDTH 0.1c

echo [3/5] Create basemap
gmt basemap -JM7.5/17 -R9:20/10:40/54:10/55:10 -B+t"Exploration of the Baltic Sea"+s"A map made by Christopher Mahn" -Xc -Yc -Lx8.5c/-1c+c54+w50k+f+u -Vw
gmt grd2cpt ./data/GEBCO_BalticSea.nc -C"./data/wiki-2.0_mod.cpt" -Sh -E27 -Z -Vw
gmt grdimage ./data/GEBCO_BalticSea.nc -I+a315+ne0.15
gmt colorbar -Dx0c/-2c+w17c/0.35c+h -B20+l"Elevation" -Vw

echo [4/5] Adding Points, Labels and Lines
gmt coast -Bxa0.5g0.5 -Bya0.25g0.25 -Df -W1p,120/120/120 -Ia/2p,0/0/255 -N1/1p,255/127/0 -Vw
gmt plot ./data/track.xy -W1p,red -Vw
gmt plot ./data/Baltic_Sea-cities.txt -Sc7p -Gwhite -W1p,black -Vw
gmt text ./data/Baltic_Sea-cities.txt -F+f+a+j -Dj3p/4p -Vw

echo [5/5] Finishing
gmt end
