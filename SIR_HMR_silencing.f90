program minimal_SIR

!! Numerical simulation of a stochastic chemical reaction network using Gillespie's algorithm.
	!Variable declaration
	integer, parameter :: dp = selected_real_kind(15, 307)
	integer :: tot_time, t1, k, SIRcountEND, i, j, concl, trans_sil, numnuc
	integer, dimension(:), allocatable :: silence, transit
	integer, dimension(:), allocatable :: X, Xnew, Xrest, Xrep, Xbef, Xaft
	integer, dimension(:,:), allocatable :: p, profile
	real(kind=dp), dimension(11) :: stats
	real(kind=dp), dimension(:), allocatable :: a
	real(kind=dp) :: r1, r2, rn, ti, tk, mu, A0
	real(kind=dp), dimension(:), allocatable :: Xcumule, Xcumuls, trans_bef, trans_after, sil_dist, weights
	real(kind=dp), dimension(:), allocatable :: trans_after_e, trans_bef_e
	character (len=90) :: filename


	!Related to nucleosomes
	integer :: Ncop, Nsp , distSil, L, tot_ubef, tot_uaft
	real(kind=dp) :: interac, vol_max, prob_inh

	!Related to reaction
	real(kind=dp) :: ksas2, kdeac, ksir2, kdot1, hst2,  cycle_ac, kei, ken, kin
	real(kind=dp) ::  csir, norm, mean, meane, meani, meann, KKe,KKi,KKn, KKd
	real :: alpha, kdsqeff, tauS
	real(kind=dp), dimension(:), allocatable :: vol_locus
	!real, dimension(:,:), allocatable :: bin_prob2
	real :: Knorm, meanDim
	integer ::Nreact

	!Related to generations
	integer :: gen, tgen, sil_seq, max_after
	real(kind=dp) :: gen_time, time, tau
	real, dimension(:), allocatable :: ver_trans, ver_sil
	real(kind=dp), dimension(:,:), allocatable :: rep_stats
	real(kind=dp):: switch_est, bin_cum

	call random_seed()


	Nsp=8
	Nreact=15

  !In generation time units - except for sir2 mediated deac.
	!Latest parameters: Waterborg input !first exclamation mark: 2206
	ksas2=0.75!0.75
	kdeac=0.0!0.0 Background deacetylation rate. Supressed throught the simualtions.
	ksir2=2.1!2.6, 1.8 and 6 kd , 14 kd and 8 norm bin
	kdot1=0.05 ! this is 0901
	hst2=0.00!0.4 !Background acet./deacet. rate (cell cycle dependent. Not used in most simulations).

	gen_time=10.0 !Time in units of 12 minutes
	tgen=100000
	tauS=0.013 ! roughly 10s in units of 12 mins

! Only dimerisation
! 8 states 1) Binding to both silencers 2) E-silencer+nucleosome 3) I-silencer+nucleosome
!					4) unmod unbound 5) bound dimer 6) methylated & acetyl. 7) acetylated 8) methyl but no acetyl
! 15 reactions 1) sas2 acetylation
!							2) sir2 deacetylation
!							3) dot1 methylation [should be slower than sas2 & sir2, we believe]
! 						4) sas2 acetylation of only methyl tetramer
!							5) sir2 deacet. of methyl & acetyl tetramer.
!							6) ei binding								7) ei unbinding
!							8) en binding							  9) en unbinding
!							10) in binding								11) in unbinding
!							12) dimerisation in bulk			13) unbinding of the dimer
!							14) background deacetylation (mostly cell cycle dependent)
!							15) background deacetylation of methyl & acetyl

	allocate (X(Nsp), Xnew(Nsp), Xbef(Nsp), Xaft(Nsp), Xrest(4), Xrep(4))
	allocate (Xcumule(6),Xcumuls(6))
	allocate (p(Nreact,Nsp))
	allocate (a(Nreact))

	allocate(silence(tgen), transit(tgen))
	allocate(ver_trans(tgen), ver_sil(tgen))
	allocate(rep_stats(tgen,3))

		distSil=24 !In histone tetramers, not octamers.
		L=distSil
		allocate(vol_locus(L+1))
		allocate (trans_bef_e(L+1), trans_after_e(L+1))
		allocate (trans_bef(L+1), trans_after(L+1), sil_dist(L+1), weights(L+1))
		allocate(profile(distSil+3,2))

	csir=0.25


	KKd=0.5!0.5 wt and 0.3 for myc
	KKe=0.6
	KKi=0.6
	KKn=0.4
	ken=2*KKd*KKe*KKn*csir/tauS!KKe*KKn*KKd)
	kin=2*KKd*KKi*KKn*csir/tauS
	kei=KKd*KKe*KKi*csir/(tauS)
	kk=3*KKd*KKn*KKn*csir/tauS

	!Simple scaling for locus size as function of acetylation.
	!Volume as a function of acetylation (i.e. strength of attractive DNA-H4tail interaction)
	!Plus a potential scaling with total number of nucleosomes.
	!Swelling of the locus... (density)

	vol_locus(:)=0.0
	interac=2.375!7.0
	vol_max=3.375!8.0
	do k=1,L+1
		!To be specified and polished.
		vol_locus(k)=vol_max/(1+interac*((k-1)/float(L)))!4.25!
	enddo
	!write(*,*) vol_locus(:)

	profile(:,:)=0

	p(1,:)=(/0,0,0,-1,0,0,1,0/) !sas2 acet
	p(2,:)=(/0,0,0,1,0,0,-1,0/)	!sir2 deacet
	p(3,:)=(/0,0,0,0,0,1,-1,0/)	!dot1 meth
	p(4,:)=(/0,0,0,0,0,1,0,-1/)	!sas2
	p(5,:)=(/0,0,0,0,0,-1,0,1/) !sir2
	p(6,:)=(/1,0,0,0,0,0,0,0/)  !ei
	p(7,:)=(/-1,0,0,0,0,0,0,0/)
	p(8,:)=(/0,1,0,-1,0,0,0,0/) !en
	p(9,:)=(/0,-1,0,1,0,0,0,0/)
	p(10,:)=(/0,0,1,-1,0,0,0,0/) !in
	p(11,:)=(/0,0,-1,1,0,0,0,0/)
	p(12,:)=(/0,0,0,-2,2,0,0,0/)! dimer binding
	p(13,:)=(/0,0,0,2,-2,0,0,0/)! dimer unbinding
	p(14,:)=(/0,0,0,1,0,0,-1,0/)! Background deacet.
	p(15,:)=(/0,0,0,0,0,-1,0,1/)! Background deacet.

	X=(/0,0,0,12,0,0,12,0/)

	!open (unit=8,status="old", file="evol_trial.dat", action="write")
	!open (unit=11,status="old", file="rep_histos.dat", action="write")

	!write (filename, '("profiles_f_H3K79M_sir4t_", I2.2,".dat" )') concl-1
	!open (unit=10,status="old", file=filename, action="write")


	Xcumule(:)=0.0
	Xcumuls(:)=0.0
	trans_bef(:)=0.0
	trans_after(:)=0.0
	trans_bef_e(:)=0.0
	trans_after_e(:)=0.0
	sil_dist(:)=0.0
	trans_sil=0.0
	time=0.0
	Xnew=X
	call random_seed()
	outer: do i=1,tgen
		ti=i*gen_time
		meanDim=0.0
		do k=1,50
			tk=(i-1)*gen_time+k*gen_time/50.0
			do while (time .lt. tk)
				!Reaction occurs. State of the system after reaction.
				X(:)=Xnew(:)
				!write (*,*) X
				!Computes the type of the next reaction.
				call random_number(r2)
				if (X(6)+X(8)==distSil) then
					time=ti
				else
					!Now we can write down the reaction propensities.
					!if ((tk-(i-1)*gen_time).lt.5.0) then
					!	cycle_ac=hst2
					!else
						cycle_ac=0.0
					!endif
					a(1)=(ksas2+cycle_ac)*X(4)
					a(2)=ksir2*X(7)*(2*(X(1)+X(2)+X(3))+X(5))/(L*vol_locus(X(4)+X(5)+X(3)+X(2)+X(8)+1)/12.0)
					a(3)=kdot1*X(7)
					a(4)=(ksas2+cycle_ac)*X(8)
					a(5)=ksir2*X(6)*(2*(X(1)+X(2)+X(3))+X(5))/(L*vol_locus(X(4)+X(5)+X(3)+X(2)+X(8)+1)/12.0)
					a(6)=kei*(1-X(1)-X(2))*(1-X(3))*24/(L*vol_locus(X(4)+X(5)+X(3)+X(2)+X(8)+1))
					a(7)=X(1)/tauS
					a(8)=ken*X(4)*(1-X(1)-X(2))*24/(L*vol_locus(X(4)+X(5)+X(3)+X(2)+X(8)+1))
					a(9)=X(2)/tauS
					a(10)=kin*X(4)*(1-X(1)-X(3))*24/(L*vol_locus(X(4)+X(5)+X(3)+X(2)+X(8)+1))
					a(11)=X(3)/tauS
					a(12)=kk*X(4)*(X(4)-1)*24/(L*vol_locus(X(4)+X(5)+X(3)+X(2)+X(8)+1)*2.0)
					a(13)=X(5)/(2.0*tauS)
					a(14)=(hst2-cycle_ac)*X(7)/2.0
					a(15)=(hst2-cycle_ac)*X(6)/2.0
					A0=sum(a)
					mu=r2*A0
					do j=1,Nreact
						if (mu .lt. sum(a(1:j))) then
							Xnew(:)=X(:)+p(j,:)
							exit
						endif
					enddo
					call random_number(r1)
					tau=1/A0*log(1/r1)
					time=tau+time
					if (time.gt.ti) then
						time=ti
					endif
				endif
			enddo
			!if (k==2.and.i.lt.5) then
			!	write (*,*) time/10.0,  X
			!endif
			!write (unit=8, fmt=*) time/10.0,  2*(X(1)+X(2)+X(3))+X(5),X(6)+X(7), X(6)+X(8)
			profile(X(6)+X(7)+1,1)=profile(X(6)+X(7)+1,1)+1 !Acetyl
			profile(X(1)*2+X(2)+X(3)+X(5)+1,2)= &
																profile(X(1)*2+X(2)+X(3)+X(5)+1,2)+1
		enddo
		if ((X(2)+X(3)+X(4)+X(5)).lt.distSil/2.0) then
			silence(i)=1
			Xcumule(:)=Xcumule(:)+(/1.0_dp*(X(6)+X(7)),1.0_dp*(X(6)+X(8)),1.0_dp*(X(5)+X(2)+X(3)),1.0_dp*(X(4)),&
																				1.0_dp*(X(1)+X(2)),1.0_dp*(X(1)+X(3))/)
			if (silence(i-1)==0) then
				tot_ubef=Xbef(2)+Xbef(3)+Xbef(4)+Xbef(5)
				tot_uaft=Xaft(2)+Xaft(3)+Xaft(4)+Xaft(5)
				rep_stats(i,1)=tot_ubef
				rep_stats(i,2)=tot_uaft
				!Assumes prob_inh=0.5
				rep_stats(i,3)=factorial(tot_ubef)/(factorial(tot_uaft)*factorial(tot_ubef-tot_uaft))
				!trans_bef(:)=trans_bef(:)+(/1.0_dp*(Xbef(8)+Xbef(9)),1.0_dp*(Xbef(8)+Xbef(10)),&
				!		1.0_dp*(Xbef(7)+Xbef(4)+Xbef(5)),1.0_dp*(Xbef(6))/)
				!trans_after(:)=trans_after(:)+(/1.0_dp*(Xaft(8)+Xaft(9)),1.0_dp*(Xaft(8)+Xaft(10)), &
				!		1.0_dp*(Xaft(7)+Xaft(4)+Xaft(5)),1.0_dp*(Xaft(6))/)
				!Genereation per generation replication dynamics
				trans_sil=trans_sil+1
				trans_bef(tot_ubef+1)=trans_bef(tot_ubef+1)+1.0
				trans_after(tot_uaft+1)=trans_after(tot_uaft+1)+1.0
			endif
		else
			!write (unit=9, fmt=*) i, 0
			silence(i)=0
			Xcumuls(:)=Xcumuls(:)+(/1.0_dp*(X(6)+X(7)),1.0_dp*(X(6)+X(8)),1.0_dp*(X(5)+X(2)+X(3)),1.0_dp*(X(4)), &
																	1.0_dp*(X(1)+X(2)),1.0_dp*(X(1)+X(3))/)
			sil_dist(X(2)+X(3)+X(4)+X(5)+1)=sil_dist(X(2)+X(3)+X(4)+X(5)+1)+1.0
			if (silence(i-1)==1) then
				trans_bef_e(Xbef(6)+Xbef(8)+1)=trans_bef_e(Xbef(6)+Xbef(8)+1)+1.0
				trans_after_e(Xaft(6)+Xaft(8)+1)=trans_after_e(Xaft(6)+Xaft(8)+1)+1.0
			endif
		endif
		Xnew(:)=X(:)
		Xrest=(/X(2)+X(3)+X(4)+X(5),X(6),X(7),X(8)/)
		Xrep=(/X(2)+X(3)+X(4)+X(5),X(6),X(7),X(8)/)
		prob_inh=0.5
		Xbef=X
		do k=1, L/2
		call random_number(r1)
			!First tetramer of the nucleosome exchange
			call random_number(r2)
			if (r2*sum(Xrest(:)).lt.Xrest(1)) then
				if (r1 .lt. (1-prob_inh)) then
					Xrep(:)=Xrep(:)+(/-1,0,1,0/)
				endif
				Xrest(:)=Xrest(:)+(/-1,0,0,0/)
			elseif (r2*sum(Xrest(:)).lt.(Xrest(2)+Xrest(1))) then
				if (r1 .lt. (1-prob_inh)) then
					Xrep(:)=Xrep(:)+(/0,-1,1,0/)
				endif
				Xrest(:)=Xrest(:)+(/0,-1,0,0/)
			elseif (r2*sum(Xrest(:)).lt.sum(Xrest(1:3))) then
				Xrest(:)=Xrest(:)+(/0,0,-1,0/)
			else
				if (r1 .lt. (1-prob_inh)) then
					Xrep(:)=Xrep(:)+(/0,0,1,-1/)
				endif
				Xrest(:)=Xrest(:)+(/0,0,0,-1/)
			endif
			!Second tetramer of the nucleosome exchange
			call random_number(r2)
			if (r2*sum(Xrest(:)).lt.Xrest(1)) then
				if (r1 .lt. (1-prob_inh)) then
					Xrep(:)=Xrep(:)+(/-1,0,1,0/)
				endif
				Xrest(:)=Xrest(:)+(/-1,0,0,0/)
			elseif (r2*sum(Xrest(:)).lt.(Xrest(2)+Xrest(1))) then
				if (r1 .lt. (1-prob_inh)) then
					Xrep(:)=Xrep(:)+(/0,-1,1,0/)
				endif
				Xrest(:)=Xrest(:)+(/0,-1,0,0/)
			elseif (r2*sum(Xrest(:)).lt.sum(Xrest(1:3))) then
				Xrest(:)=Xrest(:)+(/0,0,-1,0/)
			else
				if (r1 .lt. (1-prob_inh)) then
					Xrep(:)=Xrep(:)+(/0,0,1,-1/)
				endif
				Xrest(:)=Xrest(:)+(/0,0,0,-1/)
			endif
		enddo
	!	write (*,*) Xrest, Xrep
	Xnew(:)=(/0,0,0,Xrep(1),0,Xrep(2),Xrep(3),Xrep(4)/)
	X=Xnew
	Xaft=X
	!Statistics for unmodified nucleosomes after and before replication.
	!write (*,*)  X
	!write (unit=8, fmt=*) time/10.0, 2*(X(1)+X(2)+X(3))+X(5),X(6)+X(7), X(6)+X(8)

	enddo outer

	!close (unit=8)
	!close (unit=9)

	transit(:)=0
	do i=1,tgen-1
		if (silence(i).ne.silence(i+1)) then
			transit(i)=1
		endif
	enddo
	write (*,*) sum(silence(:))/float(tgen), sum(transit(:))/float(2*tgen)


	ver_trans(:)=0
	do i=1,1!numnuc
	  sil_seq=0
	  do k=1,tgen-2
	  	if ((transit(k+1)+transit(k+2))==0.and.MOD(sil_seq,2)==1) then
	  		ver_trans(k)=transit(k)
	  		sil_seq=0
	  	elseif (transit(k+1)==1) then
	  		sil_seq=sil_seq+1
	  	endif
	  enddo
	enddo

	do i=1,1!numnuc
	  if (silence(2)==1) then
	    ver_sil(1)=1
	  else
	    ver_sil(1)=0
	  endif
	  do k=2,tgen
	    if (ver_trans(k)==1) then
	      ver_sil(k)=-ver_sil(k-1)+1
	    else
	      ver_sil(k)=ver_sil(k-1)
	    endif
	  enddo
	enddo

	write (*,*) sum(transit(:)), sum(ver_trans(:))
	write (*,*) sum(ver_sil(:))/float(tgen), sum(ver_trans(:))/float(2*tgen)
	write (*,*) Xcumule(:)/float(sum(silence(:)))
	write (*,*) Xcumuls(:)/float(tgen-sum(silence(:)))
	write (*,*) trans_sil

stats(1)=sum(silence(:))/float(tgen)
stats(2)=sum(transit(:))/float(2*tgen)
stats(3)=sum(ver_sil(:))/float(tgen)
stats(4)=sum(ver_trans(:))/float(2*tgen)
stats(5)=stats(4)/stats(3)
stats(6)=stats(4)/(1-stats(3))
stats(7)=sqrt(tgen*stats(4))/(tgen*stats(4))
stats(8)=(stats(1)-stats(3))/stats(1)
stats(9)=(1+stats(7))*(1+stats(8))
stats(10)=stats(5)*stats(9)-stats(5)
stats(11)=stats(6)*stats(9)-stats(6)
	write (*,*) 4+2*numnuc, stats



	deallocate(vol_locus)
	deallocate (trans_bef_e, trans_after_e)
	deallocate (trans_bef, trans_after, sil_dist, weights)
	deallocate(profile)


deallocate (X, Xnew, Xrest)
deallocate (Xcumule,Xcumuls)
deallocate (p)
deallocate (a)

deallocate(silence, transit)
deallocate(ver_trans, ver_sil)
deallocate(rep_stats)


close(unit=9)


contains

	recursive function factorial( n ) result (f)
		real :: f
    integer :: n
		if( n == 1 ) then
			 f = 1
		 elseif (n==0) then
			 f=1
		 else
       f = n * factorial( n - 1 )
		 end if
	 end function factorial


end program minimal_SIR
