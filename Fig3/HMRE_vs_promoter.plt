set terminal pdfcairo enhanced color lw 2 size 8,4 font 'Sans-Bold, 18'
set output 'HMRE_vs_bulk.pdf'

set size 2,1

set multiplot layout 1,2

set xrange [0.0:1.0]
set yrange [0.0:1.0]

set label 1 "A" at screen 0.01,0.95 font ",32"
set label 2 "B" at screen 0.52,0.95 font ",32"

set key bottom right
set ylabel 'HMRE binding' offset 1,0
set xlabel 'Nucleosome binding'
plot 'bulk_vs_HMRE_xyerror.txt' using 1:2:3:4 with xyerror ps 2 pt 7 title 'Experiment',\
'ChIP_muts.dat' using 2:3 ps 1.5 pt 5 title 'Model'
#'HMRE_bulk.dat' using 1:2 with line lt 3 lw 2 title 'Det. approx.'

set xrange [0.0:1.0]
set yrange [0.0:1.0]

set key bottom right
set ylabel 'HMRE binding' offset 1,0
set xlabel 'Nucleosome binding'
plot 'bulk_vs_HMRE_titr_xyerror.txt' using 1:2:3:4 with xyerrorbars ps 2 pt 7 title 'Experiment',\
'ChIP_titr.dat' using 2:3 ps 1.5 pt 5 title 'Model'

unset multiplot