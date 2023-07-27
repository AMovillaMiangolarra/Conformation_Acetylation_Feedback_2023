set terminal pdfcairo enhanced color lw 2 size 12,4 font 'Sans, 24'
set output 'Bcoeffs.pdf'

set size 3,1

set multiplot layout 1,3

unset key
set yrange [0:1]
set xrange [0:0.5]
set title 'wild type'
set xtics 0,0.1,0.4
set ylabel 'BC' offset 1,0
set xlabel 'Sir4 ({/Symbol m}M)'
plot 'BC_strains.dat' using 1:2 with lp pt 9 lw 2 ps 1 linecolor 'red' title 'Model',\
'BC_exp_strains.dat' using 1:2 with lp pt 7 ps 0.75 linecolor'blue'


set title '{/Sans-Italic rap1}{/Symbol D}'
set ylabel 'BC' offset 1,0
set xlabel 'Sir4 ({/Symbol m}M)'
plot 'BC_strains.dat' using 1:3 with lp pt 9 lw 2 ps 1 linecolor 'red' title 'Model',\
'BC_exp_strains.dat' using 1:3 with lp pt 7 ps 0.75 linecolor'blue'

set title '{/Sans-Italic sir1}{/Symbol D}'
set ylabel 'BC' offset 1,0
set xlabel 'Sir4 ({/Symbol m}M)' 
plot 'BC_strains.dat' using 1:4  with lp pt 9 lw 2 ps 1 linecolor 'red' title 'Model',\
'BC_exp_strains.dat' using 1:4 with lp pt 7 ps 0.75 linecolor'blue'

#set title 'H3K79M'
#set ylabel 'BC'  offset 1,0
#set xlabel 'Sir4 ({/Symbol m}M)'
#plot 'BC_strains.dat' using 1:5 with lp pt 9 lw 2 ps 1 linecolor 'red' title 'Model'



unset multiplot