echo Script written by Christopher Mahn
echo [1/5] Begin image
gmt begin task_1 jpg

echo [2/5] Set GMT-Settings
gmt gmtset PROJ_ELLIPSOID WGS-84
gmt gmtset FORMAT_GEO_MAP ddd:mm
gmt gmtset PS_MEDIA A4
gmt gmtset MAP_FRAME_WIDTH 0.1c

echo [3/5] Create basemap
gmt basemap -JM7.5/17 -R30/40/22/32 -B+t"Ships passing through Sues canal"+s"A map made by Christopher Mahn" -Xc -Yc -Lx8.5c/-1c+c8.5+w1000k+f+u -Vw
gmt grd2cpt ./data_task_1/gebco_2023_n32.5_s8.5_w30.0_e45.0.nc -C"./data_task_1/wiki-2.0_mod.cpt" -Sh -E27 -Z -Vw
gmt grdimage ./data_task_1/gebco_2023_n32.5_s8.5_w30.0_e45.0.nc -I+a315+ne0.15
gmt colorbar -Dx0c/-2c+w17c/0.35c+h -B1000+l"Elevation [m]" -Vw

echo [4/5] Adding Points, Labels and Lines
gmt coast -Bxa1g1 -Bya1g1 -Df -W1p,120/120/120 -Ia/2p,0/0/255 -N1/1p,255/127/0 -Vw
gmt plot ./data_task_1/ships.txt -Sc5p -Gwhite -W1p,black -Vw
gmt text ./data_task_1/ships.txt -F+f+a+j -Dj3p/4p -Vw

echo [5/5] Finishing
gmt end
