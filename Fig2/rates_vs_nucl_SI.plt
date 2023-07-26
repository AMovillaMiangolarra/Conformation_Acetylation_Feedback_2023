set term pdfcairo size 10,10 font "Sans, 32"
set termoption enhanced
set output 'trans_nucl_number_SI.pdf'

set size 2,2

set label 1 "{/:Bold A}" at screen 0.01,0.98 font ",42"
set label 2 "{/:Bold B}" at screen 0.52,0.98 font ",42"
set label 3 "{/:Bold C}" at screen 0.01,0.49 font ",42"
set label 4 "{/:Bold D}" at screen 0.52,0.49 font ",42"

set multiplot 

set origin -0.03,0.5
set size 0.55,0.5
set xrange [5:13]
set yrange [0:0.3]
set xtics 6,2,12
set xlabel 'Nucleosome number' offset 0.0,0.5
set ylabel 'Silencing estab. rate (1/gen.)' offset 1.5,0.0
set ytics 0,0.05,0.25
plot 'Saxton_2E_2019.txt' using 1:2:3:4 with yerrorbars linecolor 'red' pt 7 ps 1.5 lw 4 title 'Saxton, 2019',\
'stats_old.dat' using 1:6 with linespoints linecolor 'black' lw 1.5 ps 2 lt 5 title 'Model'

set origin 0.48,0.5
set size 0.55,0.5
set xrange [5:13]
set yrange [0:0.045]
set xlabel 'Nucleosome number' offset 0.0,0.5
set ylabel 'Silencing loss rate (1/gen.)' offset 1.5,0.0
set ytics 0,0.01,0.04
plot 'Saxton_2D_2019.txt' using 1:2:3:4 with yerrorbars linecolor 'red' pt 7 ps 1.5 lw 4 title 'Saxton, 2019',\
'stats_old.dat' using 1:7 with linespoints lc 'black' lw 1.5 ps 2 lt 5 title 'Model'

set origin -0.03,0.0
set size 0.55,0.5
set xrange [5:17]
set xtics 6,2,16
set yrange [0:0.3]
set ytics 0,0.05,0.25
set xlabel 'Nucleosome number' offset 0.0,0.5
set ylabel 'Silencing estab. rate (1/gen.)' offset 1.5,0.0
plot 'Saxton_2E_2019.txt' using 1:2:3:4 with yerrorbars linecolor 'red' pt 7 ps 1.5 lw 4 title 'Saxton, 2019',\
'experiments_larger_locus.txt' using 1:8:11:12  with yerrorbars linecolor 'blue' pt 7 ps 1.5 lw 4 title 'Experimental',\
'stats_old.dat' using 1:6 with linespoints lc 'black' lw 1.5 ps 2 lt 5 title 'Model'


set origin 0.48,0.0
set size 0.55,0.5
unset key
set xrange [5:17]
set yrange [0:0.045]
set ytics 0,0.01,0.04
set xlabel 'Nucleosome number' offset 0.0,0.5
set ylabel 'Silencing loss rate (1/gen.)' offset 1.5,0.0
plot 'Saxton_2D_2019.txt' using 1:2:3:4 with yerrorbars linecolor 'red' pt 7 ps 1.5 lw 4 title 'Saxton & Rine, 2019',\
'experiments_larger_locus.txt' using 1:7:9:10 with yerrorbars linecolor 'blue' pt 7 ps 1.5 lw 4 title 'Experimental',\
'stats_old.dat' using 1:7 with linespoints lc 'black' lw 1.5 ps 2 lt 5 title 'Model'

