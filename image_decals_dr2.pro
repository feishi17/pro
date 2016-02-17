;+
; Name: image_decals_dr2
; Purpose: get image sub-data within a radius for DECals.
; Input: ra, dec
;  fileimage: file name of image, for example: 'decals-0001m002-image-g.fits'
;  arcsec: radius in units of arcsec
; Output: datanew1: 
; Need procedure: angsep
; History: 
;  Created: Dec 29 2015
; Author: Qian Yang, PKU/Steward, qianyang.astro@gmail.com
;-
;------------------------------------------------------------
pro image_decals_dr2,ra,dec,fileimage,arcsec,datanew1=datanew1
	data=mrdfits(fileimage,0,hdr,/silent,/fscale)
	matri=[[sxpar(hdr,'cd1_1'),sxpar(hdr,'cd1_2')],[sxpar(hdr,'cd2_1'),sxpar(hdr,'cd2_2')]]
	ref=[sxpar(hdr,'CRVAL1'),sxpar(hdr,'CRVAL2')]
	del_ra=ra-ref[0]
	del_dec=dec-ref[1]
	anti_matri=MATRIX_POWER(matri,-1)
	arr=[del_ra,del_dec]
	resultt=anti_matri#arr
	del_x=resultt[0]
	del_y=resultt[1]
	x=round(sxpar(hdr,'CRPIX1')+del_x)
	y=round(sxpar(hdr,'CRPIX2')+del_y)
	off=round(arcsec/0.262)
	x0=x-off
	x1=x+off
	y0=y-off
	y1=y+off
	if (x0 lt 0) then begin
		x0=0
	endif
	if (y0 lt 0) then begin
		y0=0
	endif
	if (x1 gt sxpar(hdr,'NAXIS1')-1) then begin
		x1=sxpar(hdr,'NAXIS1')-1
	endif
	if (y1 gt sxpar(hdr,'NAXIS2')-1) then begin
		y1=sxpar(hdr,'NAXIS2')-1
	endif
	datanew1=data[x0:x1,y0:y1]
end
