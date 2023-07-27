set terminal png size 1000,2000
set output 'profiles_titrations_actmod.png'

set size 3,16

set multiplot layout 16,3
set style fill transparent solid 0.5

set xrange [0.0:1.0]
set yrange [0:2500000]
set ytics ("0.0" 0.0, "0.25" 1250000, "0.5" 2500000)
set xtics (0.0, 0.25, 0.5 ,0.75, 1.0)

concs = "050 059 069 078 088 097 101 116 125 144 168 192 239 286 333 380"

do for [i = 1:16] {
	filename = 'profiles_f_wild_sir4t_'.word(concs,i).'.dat'
	plot filename using 1:2 with boxes lc 'red' notitle
	filename = 'profiles_f_rap1_sir4t_'.word(concs,i).'.dat'
	plot filename using 1:2 with boxes lc 'red' notitle
	filename = 'profiles_f_sir1_sir4t_'.word(concs,i).'.dat'
	plot filename using 1:2 with boxes lc 'red' notitle
	}

unset multiplot
	