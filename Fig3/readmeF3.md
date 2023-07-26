How to reproduce Fig. 3 in the main text.

The model runs for all histone mutants (except H4K16Q) from the file Full_SIR_full_0203F3.f90. For the H4K16Q mutant, Full_SIR_full_0203F3K16Q.f90, and for the titration Full_SIR_full_0203F3_titr.f90. This produces the outputs ChIP_muts.dat and ChIP_titr.dat, which with the reanalysed experimental data (see below, output stored in bulk_vs_HMRE_titr_xyerror.txt and bulk_vs_HMRE_xyerror.dat), can produce Fig. 3 from the main text with the script HMRE_vs_promoter.plt

We reanalysed the experimental data from Saxton and Rine, Molecular Cell, 2022, in order to estimate the value of Sir binding at the E silencer and at the nucleosomes. The analysis is performed in ChIP_AUC.ipynb and the data can be accessed upon request.
