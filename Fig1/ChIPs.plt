set terminal svg size 250,500
set output 'ChIPs.svg'

set size 1,3
set datafile separator ","

set multiplot

set style fill transparent solid noborder

set font 'Arial-Bold, 20'

set parametric

set origin 0,0.666
set size 1.0,0.334
set trange [0:1]
set xrange [-0.5:1.5]
set yrange [0.0:1.0]
set xtics ("E" 0, "I" 1)
unset key

#Weights for the silence and expressed simulations from Saxton & Rine, 2022

plot 'ChIP_sim.dat' using 1:($3*0.92+$2*0.08) with boxes lc 'red' title 'Model sil.',\
'' using 1:($3*0.09+$2*0.91) with boxes lc 'blue' title 'Model exp.',\
'Saxton_2022_1D.csv' using 1:2 with line lw 3 lc 'red' title 'Exp. sil.',\
'' using 3:4 with line lw 3 lc 'blue' title 'Exp. exp.',\
0,t lc 'gray' noti,\
1,t lc 'gray' noti

set origin 0,0.333
set size 1.0,0.334
set title ""
unset key
plot 'ChIP_sim.dat' using 1:($4*0.95+$5*0.05) with boxes lc 'blue' title 'Model exp.',\
'' using 1:($4*0.07+$5*0.93) with boxes lc 'red' title 'Model sil.',\
'Saxton_2022_1H.csv' using 1:2 with line lw 3 lc 'red' title 'sil',\
'' using 3:4 with line lw 3 lc 'blue' title 'exp',\
0,t lc 'gray' noti,\
1,t lc 'gray' noti

set origin 0,0.0
set size 1.0,0.334
unset key
plot 'ChIP_sim.dat' using 1:($6*0.93+$7*0.07) with boxes lc 'blue' title 'Model exp.',\
'' using 1:($6*0.05+$7*0.95) with boxes lc 'red' title 'Model sil.',\
'Saxton_2022_1J.csv' using 1:2 with line lw 3 lc 'red' title 'sil',\
'' using 3:4 with line lw 3 lc 'blue' title 'exp',\
0,t lc 'gray' noti,\
1,t lc 'gray' noti


unset multiplot