set term svg size 600, 300
set output 'trans_nucl_number.svg'

set size 1,2

set label 1 "{/:Bold A}" at screen 0.02,0.9 font ",32"
set label 2 "{/:Bold B}" at screen 0.52,0.9 font ",32"

set multiplot 

unset key
set origin -0.03,0.0
set size 0.55,1.0
set xrange [11:17]
set yrange [0:0.15]
set xtics 12,2,16
set xlabel 'Nucleosome number' offset 0.0,0.5
set ylabel 'Silencing estab. rate (1/gen.)' offset 1.5,0.0
set ytics 0,0.02,0.12
plot 'experiments_larger_locus.txt' using 1:8:11:12 with yerrorbars linecolor 'blue' pt 7 ps 1.5 lw 4 

set origin 0.48,0.0
set size 0.55,1.0
set xrange [11:17]
set yrange [0:0.05]
set xlabel 'Nucleosome number' offset 0.0,0.5
set ylabel 'Silencing loss rate (1/gen.)' offset 1.5,0.0
set ytics 0,0.01,0.04
plot 'experiments_larger_locus.txt' using 1:7:9:10 with yerrorbars linecolor 'blue' pt 7 ps 1.5 lw 4 

unset multiplot