;+
; Name: decals_mag2flux_arr
; Purpose: convert DECals magnitude [g,r,z] to flux
; Input: 
;  arr: DECAM_FLUX in tractor catalog, in units of nanomaggies
;  err: DECAM_FLUX_IVAR in tractor catalog, in units of 1/nanomaggies²
;  see page http://legacysurvey.org/dr2/catalogs/
; Output:
;  fu, feu: flux and flux error in units of erg*s-1*cm-2*Hz-1
;  fl, fel: flux and flux error in units of erg*s-1*cm-2*A-1
; History: Dec 7 2015
; Author: Qian Yang, PKU/Steward, qianyang.astro@gmail.com
;-
;------------------------------------------------------------
pro decals_mag2flux_arr,arr,err,fu=fu,feu=feu,fl=fl,fel=fel,Ebv
c = 2.99792458*1e18 ;A/s
n=n_elements(arr[0,*])
wave=[4750.d,6350.d,9250.d,] ;A, http://www.ctio.noao.edu/noao/content/decam-overview
wave_arr=fltarr(3,n)
wave_arr[0,*]=wave[0]
wave_arr[1,*]=wave[1]
wave_arr[2,*]=wave[2]
fu=arr*10.0d^((48.6+22.5)/(-2.5)) ;erg*s-1*cm-2*Hz-1
fl=(c*fu)/wave_arr^2 ;erg*s-1*cm-2*A-1
feu=(1.0/sqrt(err))*10.0^((48.6+22.5)/(-2.5))
fel=feu*2.998e18/wave_arr^2
;---------------------
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
