set term pdfcairo size 20,6 font "Sans, 32"
#set terminal pdfcairo enhanced color lw 2 size 2800,720 font 'Arial-Bold, 20'
set termoption enhanced
set output 'trans_sils_inset.pdf'

set size 3,1

set label 1 "{/:Bold A}" at screen 0.01,0.95 font ",40"
set label 2 "{/:Bold B}" at screen 0.735,0.95 font ",40"

set multiplot 
set style fill transparent solid noborder

set title "Wild type" offset 0,-0.5
set origin 0.0,0.0
set size 0.38,1.0
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
'' using 1:4 pt 9 ps 1.0 lc 'dark-green' title 'Sil. loss (estim)'



set title '{/Sans-Italic sir1}{/Symbol D}'
set origin 0.36,0.0
set size 0.38,1.0
set xrange [0.0:0.4]
set yrange [0.0:0.3]
set ylabel 'Transition rates (1/gen.)' offset 1.5,0
set xlabel 'Sir4 conc.'
set key at 0.41,0.3
plot 'silence_sir1.dat' using 1:6 with lp pt 9 lw 5 lc 'blue' title 'Sil. estab. (sim)',\
'' using 1:7 with lp pt 5 lw 5 lc 'orange' title 'Sil. loss (sim)',\
'Saxton_2022_2G.csv' using ($3/1060+0.05):($4/2) pt 8 ps 2.5 lc 'blue' title 'Sil. estab. (exp)' ,\
'' using ($1/1060+0.05):($2/2) pt 4 ps 2.5 lc 'orange' title 'Sil. loss (exp)' ,\
'' using 1:4 pt 9 ps 1.0 lc 'dark-green' title 'Sil. loss (estim)'

set origin 0.715,0.5
set size 0.3,0.5
unset title
set xrange [0.0:1.0]
set yrange [0.0:0.35]
set xtics 0, 0.2, 1
set ylabel 'Prob.' offset 1.5,0
set xlabel 'Unmod. fraction (Sil. loss)' offset 0,0.6
set key at 1,0.35
plot 'rep_histos.dat' using ($1/24.0):3 with boxes lc 'blue' title 'Before Replic.' ,\
'' using ($1/24.0):4 with boxes lc 'red' title 'After Replic.'


set origin 0.715,0.0
set size 0.3,0.5
set xrange [0.0:1.0]
set xtics 0, 0.2, 1
set ylabel 'Prob.' offset 1.5,0
set xlabel 'Methyl. fraction (Sil. est.)' offset 0,0.6
plot 'rep_histos.dat' using ($1/24.0):5 with boxes lc 'blue' title 'Before Replic.' ,\
'' using ($1/24.0):6 with boxes lc 'red' title 'After Replic.'


#set title 'Silencing and silencers' font myfont
#set ylabel 'Fraction of silenced cells' offset 1.0,0
#set yrange [0.0:1.0]
#set key bottom right
#plot 'silence_wt.dat' using 1:6 with line lw 2 lc 'black' title 'Wt (sim)',\
#'silence_rap1D.dat' using 1:6 with line lw 2 lc 'green' title 'Rap1{/Symbol D} (sim)',\
#'silence_sir1D.dat' using 1:6 with line lw 2 lc 'blue' title 'Sir1{/Symbol D} (sim)',\
#'Saxton_2022_4E.txt' using ($1/530):($2/100) pt 5 ps 2 lc 'black' title 'Wt (exp)',\
#'' using ($3/530):($4/100) pt 5 ps 2 lc 'green' title 'Rap1{/Symbol D} (exp)',\
#'' using ($5/530):($6/100) pt 5 ps 2 lc 'blue' title 'Sir1{/Symbol D} (exp)'

set origin 0.039,0.47
set size 0.175,0.4
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
plot 'silence_wt.dat' using 1:7 with lp pt 5 lw 5 lc 'orange',\
'' using 1:9 pt 9 ps 1.0 lc 'dark-green' ,\
'Saxton_2022_2H.csv' using ($1/1060+0.05):($2/2) pt 4 ps 2.0 lc 'orange'

set origin 0.4,0.47
set size 0.175,0.4
unset title
unset key
unset ylabel
unset xlabel
set yrange[0.003:0.25]
set xrange [0.0:0.4]
set ytics 0.01,0.1 offset 0.8,0
set xtics 0.0,0.2,0.4 offset 0,0.5
plot 'silence_sir1.dat' using 1:7 with lp pt 5 lw 5 lc 'orange',\
'' using 1:9 pt 9 ps 1.0 lc 'dark-green' ,\
'Saxton_2022_2G.csv' using ($1/1060+0.05):($2/2) pt 4 ps 2.0 lc 'orange'



unset multiplot