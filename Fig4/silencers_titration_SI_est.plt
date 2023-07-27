set term pdfcairo size 18,7 font "Sans, 32"
#set terminal pdfcairo enhanced color lw 2 size 1400,1000 font 'Arial-Bold, 20'
set termoption enhanced
set output 'trans_sils_inset_est_SI.pdf'

set size 2,1

set multiplot 
set style fill transparent solid noborder

set title "Wild type" offset 0,-0.5
set origin 0.0,0.0
set size 0.5,1.0
set xrange [0.0:0.4]
set yrange [0.0:0.45]
set xtics 0, 0.1, 0.3 nomirror
set ytics 0, 0.1, 0.4
set ylabel 'Transition rates (1/gen.)' offset 1.5,0
set xlabel 'Sir4 conc.'
set key at 0.41,0.45
plot 'silence_wt.dat' using 1:6 with lp pt 9 lw 5 lc 'blue' title 'Sil. estab. (sim)',\
'' using 1:7 with lp pt 5 lw 5 lc 'orange' title 'Sil. loss (sim)' ,\
'Saxton_2022_2H.csv' using ($3/1060+0.05):($4/2) pt 8 ps 2.5 lc 'blue' title 'Sil. estab. (exp)' ,\
'' using ($1/1060+0.05):($2/2) pt 4 ps 2.5 lc 'orange' title 'Sil. loss (exp)' ,\
'' using 1:4 pt 9 ps 1.0 lc 'dark-green' title 'Sil. estab. (estim)'



set title '{/Sans-Italic sir1}{/Symbol D}'
set origin 0.5,0.0
set size 0.5,1.0
set xrange [0.0:0.4]
set yrange [0.0:0.3]
set ylabel 'Transition rates (1/gen.)' offset 1.5,0
set xlabel 'Sir4 conc.'
set key at 0.41,0.3
plot 'silence_sir1.dat' using 1:6 with lp pt 9 lw 5 lc 'blue' title 'Sil. estab. (sim)',\
'' using 1:7 with lp pt 5 lw 5 lc 'orange' title 'Sil. loss (sim)',\
'Saxton_2022_2G.csv' using ($3/1060+0.05):($4/2) pt 8 ps 2.5 lc 'blue' title 'Sil. estab. (exp)' ,\
'' using ($1/1060+0.05):($2/2) pt 4 ps 2.5 lc 'orange' title 'Sil. loss (exp)' ,\
'' using 1:4 pt 9 ps 1.0 lc 'dark-green' title 'Sil. estab. (estim)'


set origin 0.05,0.47
set size 0.25,0.4
unset title
unset key
unset ylabel
unset xlabel
unset label 
set yrange[0.01:0.5]
set xrange [0.0:0.2]
set ytics 0.01,0.1 offset 0.8,0
set xtics 0.0,0.1,0.2 offset 0,0.5

set logscale y
plot 'silence_wt.dat' using 1:6 with lp pt 9 lw 5 lc 'blue',\
'' using 1:8 pt 9 ps 1.0 lc 'dark-green' ,\
'Saxton_2022_2H.csv' using ($3/1060+0.05):($4/2) pt 8 ps 2.0 lc 'blue'

set origin 0.55,0.47
set size 0.25,0.4
unset title
unset key
unset ylabel
unset xlabel
set yrange[0.003:0.5]
set xrange [0.0:0.4]
set ytics 0.01,0.1 offset 0.8,0
set xtics 0.0,0.2,0.4 offset 0,0.5
plot 'silence_sir1.dat' using 1:6 with lp pt 9 lw 5 lc 'blue',\
'' using 1:8 pt 9 ps 1.0 lc 'dark-green' ,\
'Saxton_2022_2G.csv' using ($3/1060+0.05):($4/2) pt 8 ps 2.0 lc 'blue'



unset multiplot