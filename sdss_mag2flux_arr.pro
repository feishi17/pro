;+
; Name: sdss_mag2flux_arr
; Purpose: convert SDSS magnitude [w1,w2,w3,w4] to flux
; Input: 
;  arr: an array of magnitude
;  err: an array of manitude error
; Output:
;  fu, feu: flux and flux error in units of erg*s-1*cm-2*Hz-1
;  fl, fel: flux and flux error in units of erg*s-1*cm-2*A-1
; History: Dec 7 2015
; Author: Qian Yang, PKU/Steward, qianyang.astro@gmail.com
;-
;------------------------------------------------------------
pro sdss_mag2flux_arr,arr,err,fu=fu,feu=feu,fl=fl,fel=fel,au
c = 2.99792458*1e18 ;A/s
n=n_elements(arr[0,*])
wave=[3557.d,4825.d,6261.d,7672.d,9097.d] ;A, Fukugita et al. 1996
wave_arr=fltarr(5,n)
wave_arr[0,*]=wave[0]
wave_arr[1,*]=wave[1]
wave_arr[2,*]=wave[2]
wave_arr[3,*]=wave[3]
wave_arr[4,*]=wave[4]
arr[0,*]=arr[0,*]-0.04-au
arr[1,*]=arr[1,*]-0.736*au
arr[2,*]=arr[2,*]-0.534*au
arr[3,*]=arr[3,*]-0.405*au
arr[4,*]=arr[4,*]+0.02-0.287*au
; arr=[u,g,r,i,z]
fu=(10.0d^(arr/(-2.5d)))*(3.361*(1e-20)) ;erg*s-1*cm-2*Hz-1
fl=(c*fu)/wave_arr^2 ;erg*s-1*cm-2*A-1
feu=fu*0.4*alog(10.d)*err
fel=fl*0.4*alog(10.d)*err
;---------
index=where(arr le 1.0)
if (min(index) ge 0) then begin
	fu[index]=0.0
	fl[index]=0.0
endif
index=where(err le 0)
if (min(index) ge 0) then begin
	feu[index]=0.0
	fel[index]=0.0
endif
;---------
end
