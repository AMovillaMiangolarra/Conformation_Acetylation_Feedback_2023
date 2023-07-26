set terminal svg size 600,225
set output 'evol_novol.svg'

set size 1,1

set style fill transparent solid noborder
set parametric

set trange [0:27]
set xrange [0:40]
set yrange [0:27]
set key at 40,27

plot for [i=1:40] i,t lw 2 lc 'gray' noti,\
'evol_novol.dat' using 1:3 with line lw 2 lc 'brown' title ' ',\
'' using 1:4 with line lw 3 lc 'blue' title ' ',\
'' using 1:2 with line lw 2 lc 'black' title ' '
