echo Script written by Christopher Mahn
echo [1/18] Begin gridding
gmt begin SA01_grid

echo [2/18] Rasterize with "Nearest Neighbor"
gmt nearneighbor "./data_task_2/Neumuehlen.txt" -R9.9125/9.9282/53.5396/53.5425 -I1.8e -S3.6e -G"./data_task_2/Neumuehlen_NN.grd" -Vw

echo [3/18] Triangulating
gmt triangulate "./data_task_2/Neumuehlen.txt" -R9.9125/9.9282/53.5396/53.5425 -I1.8e -G"./data_task_2/Neumuehlen_DT.grd" -Vw

echo [4/18] Finishing
gmt end

echo [5/18] Flipping both layers height
gmt grdmath "./data_task_2/Neumuehlen_NN.grd" -1 MUL = "./data_task_2/Neumuehlen_NN_flip.grd"
gmt grdmath "./data_task_2/Neumuehlen_DT.grd" -1 MUL = "./data_task_2/Neumuehlen_DT_flip.grd"

echo [6/18] Calculate difference of both methods
gmt grdmath "./data_task_2/Neumuehlen_NN.grd" "./data_task_2/Neumuehlen_DT.grd" SUB = "./data_task_2/Neumuehlen_diff.grd"

echo [6/18] Calculate Volume of both methods
gmt grdvolume "./data_task_2/Neumuehlen_NN_flip.grd" -C-13.8 -fg -Se -Vw > "./data_task_2/volume_NN.txt"
gmt grdvolume "./data_task_2/Neumuehlen_DT_flip.grd" -C-13.8 -fg -Se -Vw > "./data_task_2/volume_DT.txt"

# ------------------------------------------------------------------------------
echo [7/18] Begin image of nearest neighbor method
gmt begin task_2_NN jpg

echo [8/18] Set GMT-Settings
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE
gmt gmtset FORMAT_GEO_MAP ddd:mm:ss

echo [9/18] Create basemap
gmt basemap -JM7.99/20 -R9.91/9.93/53.539/53.543 -B+t"Neumühlen (nearest neighbor)"+s"A Visualisation by Christopher Mahn" -Lx8.5c/-2c+c53.5+w1000e+f+u -Xc -Yc -Vw
gmt grd2cpt ./data_task_2/Neumuehlen_NN_flip.grd -C"./data_task_2/GMT_sea.cpt" -E27 -Z -Vw
gmt grdimage "./data_task_2/Neumuehlen_NN_flip.grd" -I+a315+ne0.15 -Q -Bxa0.0027777g0.0027777 -Bya0.0013888g0.0013888 -Vw
gmt colorbar -Dx0c/-3.2c+w17c/0.35c+h -B1+l"Depth [m]" -Vw

echo [X/X] Adding Contours
gmt grdcontour "./data_task_2/Neumuehlen_NN_flip.grd" -C2 -A5+f6p,Helvetica-Bold -W0.5p,black -Vw

echo [10/18] Finishing image
gmt end

# ------------------------------------------------------------------------------
echo [11/18] Begin image of triangulation method
gmt begin task_2_DT jpg

echo [12/18] Set GMT-Settings
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE
gmt gmtset FORMAT_GEO_MAP ddd:mm:ss

echo [13/18] Create basemap
gmt basemap -JM7.99/20 -R9.91/9.93/53.539/53.543 -B+t"Neumühlen (triangulation)"+s"A Visualisation by Christopher Mahn" -Lx8.5c/-2c+c53.5+w1000e+f+u -Xc -Yc -Vw
gmt grd2cpt ./data_task_2/Neumuehlen_DT_flip.grd -C"./data_task_2/GMT_sea.cpt" -E27 -Z -Vw
gmt grdimage "./data_task_2/Neumuehlen_DT_flip.grd" -I+a315+ne0.15 -Q -Bxa0.0027777g0.0027777 -Bya0.0013888g0.0013888 -Vw
gmt colorbar -Dx0c/-3.2c+w17c/0.35c+h -B1+l"Depth [m]" -Vw

echo [X/X] Adding Contours
gmt grdcontour "./data_task_2/Neumuehlen_DT_flip.grd" -C2 -A5+f6p,Helvetica-Bold -W0.5p,black -Vw

echo [14/18] Finishing image
gmt end


# ------------------------------------------------------------------------------
echo [11/18] Begin image of difference
gmt begin task_2_difference jpg

echo [12/18] Set GMT-Settings
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE
gmt gmtset FORMAT_GEO_MAP ddd:mm:ss

echo [13/18] Create basemap
gmt basemap -JM7.99/20 -R9.91/9.93/53.539/53.543 -B+t"Neumühlen (difference of both methods)"+s"A Visualisation by Christopher Mahn" -Lx8.5c/-2c+c53.5+w1000e+f+u -Xc -Yc -Vw
gmt makecpt -C"./data_task_2/noGreen_mod.cpt" -T-0.1/0.1/0.001 -Z -Vw
gmt grdimage "./data_task_2/Neumuehlen_diff.grd" -I+a315+ne0.15 -Q -Bxa0.0027777g0.0027777 -Bya0.0013888g0.0013888 -Vw
gmt colorbar -Dx0c/-3.2c+w17c/0.35c+h -B0.025+l"Difference [m]" -Vw

echo [14/18] Finishing image
gmt end
