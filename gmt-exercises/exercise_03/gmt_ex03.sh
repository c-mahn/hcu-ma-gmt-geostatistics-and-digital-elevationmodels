echo Script written by Christopher Mahn
echo [1/18] Begin gridding
gmt begin SA01_grid

echo [2/18] Rasterize with "Nearest Neighbor"
gmt nearneighbor "./data/SA01_bathy.txt" -R7.965/8.02/54.162/54.177 -I5e -S10e -G"./data/SA01_bathy_NN.grd" -Vw

echo [3/18] Triangulating
gmt triangulate "./data/SA01_bathy.txt" -R7.965/8.02/54.162/54.177 -I5e -G"./data/SA01_bathy_DT.grd" -Vw

echo [4/18] Finishing
gmt end

echo [5/18] Calculate difference of both methods
gmt grdmath "./data/SA01_bathy_NN.grd" "./data/SA01_bathy_DT.grd" SUB = "./data/SA01_bathy_diff.grd"

echo [6/18] Calculate Volume difference of both methods
gmt grdvolume "./data/SA01_bathy_NN.grd" -C-20 -fg -Se -Vw > "./data/volume_NN.txt"
gmt grdvolume "./data/SA01_bathy_DT.grd" -C-20 -fg -Se -Vw > "./data/volume_DT.txt"

# ------------------------------------------------------------------------------
echo [7/18] Begin image of nearest neighbor method
gmt begin output_NN jpg

echo [8/18] Set GMT-Settings
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE
gmt gmtset FORMAT_GEO_MAP ddd.xx

echo [9/18] Create basemap
gmt basemap -JM7.99/20 -R7.965/8.02/54.162/54.177 -B+t"Bathymetry of region SA01"+s"A Visualisation by Christopher Mahn" -Lx8.5c/-2c+c54+w2500e+f+u -Xc -Yc -Vw
gmt makecpt -C"./data/GMT_sea.cpt" -T-32/-17.5/0.001 -Z -Vw
gmt grdimage "./data/SA01_bathy_NN.grd" -I+a315+ne0.15 -Q -Bxa0.01g0.01 -Bya0.005g0.005 -Vw
gmt colorbar -Dx0c/-3.2c+w17c/0.35c+h -B5+l"Depth [m]" -Vw

echo [10/18] Finishing image
gmt end

# ------------------------------------------------------------------------------
echo [11/18] Begin image of triangulation method
gmt begin output_DT jpg

echo [12/18] Set GMT-Settings
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE
gmt gmtset FORMAT_GEO_MAP ddd.xx

echo [13/18] Create basemap
gmt basemap -JM7.99/20 -R7.965/8.02/54.162/54.177 -B+t"Bathymetry of region SA01"+s"A Visualisation by Christopher Mahn" -Lx8.5c/-2c+c54+w2500e+f+u -Xc -Yc -Vw
gmt makecpt -C"./data/GMT_sea.cpt" -T-32/-17.5/0.001 -Z -Vw
gmt grdimage "./data/SA01_bathy_DT.grd" -I+a315+ne0.15 -Q -Bxa0.01g0.01 -Bya0.005g0.005 -Vw
gmt colorbar -Dx0c/-3.2c+w17c/0.35c+h -B5+l"Depth [m]" -Vw

echo [14/18] Finishing image
gmt end

# ------------------------------------------------------------------------------
echo [15/18] Begin image of difference of both methods
gmt begin output_diff jpg

echo [16/18] Set GMT-Settings
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE
gmt gmtset FORMAT_GEO_MAP ddd.xx

echo [17/18] Create basemap
gmt basemap -JM7.99/20 -R7.965/8.02/54.162/54.177 -B+t"Difference between nearest neighbor and triangulation"+s"A Visualisation by Christopher Mahn" -Lx8.5c/-2c+c54+w2500e+f+u -Xc -Yc -Vw
gmt makecpt -C"./data/noGreen_mod.cpt" -T-0.1/0.1/0.001 -Z -Vw
gmt grdimage "./data/SA01_bathy_diff.grd" -Q -Bxa0.01g0.01 -Bya0.005g0.005 -Vw
gmt colorbar -Dx0c/-3.2c+w17c/0.35c+h -B0.025+l"Difference [m]" -Vw

echo [18/18] Finishing image
gmt end
