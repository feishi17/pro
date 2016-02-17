;+
; Name: download_image_decals_dr2
; Purpose: download DECals dr2 image from http://portal.nersc.gov/project/cosmo/data/legacysurvey/dr2/
; Input: ra, dec, filter
; Output: 
;  fileimage1: downloaded image file name, for example: 'decals-0001m002-image-g.fits'
;  has_image: >0 when has image, otherwise 0.
; Need procedure: angsep
; History: 
;  Created: Dec 29 2015
;  Modified: Feb 16 2016, download image from dr2 release website.
; Author: Qian Yang, PKU/Steward, qianyang.astro@gmail.com
;-
;------------------------------------------------------------
function rad_arcsec,arr
	arr=double(arr)
	result=dblarr(n_elements(arr))
	pi=3.141592655
	result=arr*180.0d*3600.d/pi
	return,result
end

function rad_degree,arr
	arr=double(arr)
	result=dblarr(n_elements(arr))
	pi=3.141592655
	result=arr*180.0d/pi
	return,result
end

function degree_rad,arr
	arr=double(arr)
	result=dblarr(n_elements(arr))
	pi=3.141592655
	result=arr*pi/180.0d
	return,result
end

pro download_image_decals_dr2,ra,dec,filter,fileimage1=fileimage1,has_image=has_image
	has_image=0
	;http://portal.nersc.gov/project/cosmo/data/legacysurvey/dr2/decals-bricks-dr2.fits
	file='decals-bricks-dr2.fits'
	data=mrdfits(file,1,/silent)
	bricks=data.brickname
	ra1=data.ra1
	ra2=data.ra2
	dec1=data.dec1
	dec2=data.dec2
	rac=data.ra
	decc=data.dec
	has_image_g=data.nobs_med_g
	has_image_r=data.nobs_med_r
	has_image_z=data.nobs_med_z
	if (filter eq 'g') then begin
		has_images=has_image_g
	endif
	if (filter eq 'r') then begin
		has_images=has_image_r
	endif
	if (filter eq 'z') then begin
		has_images=has_image_z
	endif
	ra_in=(ra1-ra)*(ra2-ra)
	dec_in=(dec1-dec)*(dec2-dec)
	ind=where((ra_in le 0) and (dec_in le 0))
	print,'------- Process -------'
	if (min(ind) ge 0) then begin
		if (n_elements(ind) eq 1) then begin
			print,'Found one brick...'
			brick=bricks[ind]
			has_image=has_images[ind]
		endif else begin
			print,'Found a few bricks...'
			rac=rac[ind]
			decc=decc[ind]
			bricks=bricks[ind]
			has_images=has_images[ind]
			tmp=double(rad_arcsec(angsep(degree_rad(ra),degree_rad(dec),degree_rad(rac),degree_rad(decc))))
			tp=min(tmp,id)
			brick=bricks[id]
			has_image=has_images[id]
		endelse
	endif else begin
		print,'No such objects in Tractor CCD bricks...'
	endelse
if has_image then begin
	fileimage1='decals-'+brick+'-image-'+filter+'.fits'
	print,fileimage1
	if ~file_test(fileimage1,/read) then begin
		print,'Start to download...'
		tp='wget http://portal.nersc.gov/project/cosmo/data/legacysurvey/dr2/coadd/'+strmid(brick,0,3)+'/'+brick+'/decals-'+brick+'-image-'+filter+'.fits'+' '+fileimage1
		print,tp
		spawn,tp;,/hide, /LOG_OUTPUT
		print,'Finish downloading.'
	endif
	if ~file_test(fileimage1,/read) then begin
		print,'Warning: Failed to get file....'
		;continue
	endif
endif else begin
	print,'No such image now in Tractor... Maybe later...'
endelse
	print,'--------- End ---------'
end
