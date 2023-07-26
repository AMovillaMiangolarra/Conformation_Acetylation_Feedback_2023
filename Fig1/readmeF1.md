Code and data to reproduce Figs. 1B and 1C. Gnuplot scripts also provided.

The model is simulated in Fortran for 50 generations with the file Full_SIR_full_0203.f90. To plot the data as in Fig. 1B, running this code produces the file evol.dat, which is used by plot_exampl.plt. To plot the data without volume changes, set vol_locus(k)=2.0 in line 125, and run again the model and the gnuplot script.

To plot 
