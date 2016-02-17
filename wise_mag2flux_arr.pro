;+
; Name: wise_mag2flux_arr
; Purpose: convert WISE magnitude [w1,w2,w3,w4] to flux
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
pro wise_mag2flux_arr,arr,err,fu=fu,feu=feu,fl=fl,fel=fel
c = 2.99792458*1e18 ;A/s
wave=double([3.4e4,4.6e4,12e4,22e4]) ;A, http://casa.colorado.edu/~ginsbura/filtersets.htm
;http://wise2.ipac.caltech.edu/docs/release/allsky/expsup/sec4_4h.html#conv2flux
n=n_elements(arr[0,*])
wave_arr=fltarr(4,n)
wave_arr[0,*]=wave[0]
wave_arr[1,*]=wave[1]
wave_arr[2,*]=wave[2]
wave_arr[3,*]=wave[3]
arr[0,*]=arr[0,*]+2.699
arr[1,*]=arr[1,*]+3.339
arr[2,*]=arr[2,*]+5.174
arr[3,*]=arr[3,*]+6.620
; arr=[w1,w2,w3,w4]
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
