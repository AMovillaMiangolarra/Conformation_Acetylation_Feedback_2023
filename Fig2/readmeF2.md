Code, data and scripts to reproduce Fig. 2 and SI Fig 2 and 3.

The model is implemented in Full_SIR_full_0203F2.f90, whose output is the loss and establishment rates for loci with 6-16 nucleosomes (saved into stats_old.dat). The model with the new parameters (after correcting for the strong experimental trend) can be found in Full_SIR_full_0203F2CD.f90, whose output is the same but to file stats.dat. These outputs together with the experimental data (Saxton_2D_2019.txt, Saxton_2E_2019.txt and experiments_larger_locus.txt) allow the script rates_vs_nucl.plt to reproduce Fig. 3 in the main text. Fig4 in the SI is produced by rates_vs_nucl_SI.plt.

Finally, for SI Fig 3, the pvalues are computed in the spreadsheet Switching_rates_12_16_nucl_pvalue.xlsx, together with the raw data. The gnuplot script is rates_vs_nucl_sxp_pval.plt.
