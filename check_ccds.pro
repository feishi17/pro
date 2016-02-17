;+
; Name: check_ccds
; Purpose: check objects whether in the gaps of CCDs in DECals images
; Input: input file including ra,dec,brickname
; Output: output file including information as (for example: check_ccds.fits)
;  hasimage: 0 object in gap, otherwise 1
;  airmass,date_obs,g_seeing,exptime,propid,extname,ccdnum,cpimage,calname
; Need procedure: angsep
; History: 
;  Created: Nov 5 2015, for DECals dr1 data release, for z filter.
;  To do: change to DECals dr2 and for g,r filters.
; Author: Qian Yang, PKU/Steward, qianyang.astro@gmail.com
;-
;------------------------------------------------------------
pro check_ccds
file='example.fits' ;including id,ra,dec,brickname
data=mrdfits(file,1,hdr)
n=n_elements(data)
brickname=data.brickname
result=replicate({id:0l,ra:0.0,dec:0.0,hasimage:0l,airmass:0.0,date_obs:'',g_seeing:0.0,exptime:0.0,propid:'',extname:'',ccdnum:0l,cpimage:'',calname:''},n)
result.id=data.id
result.ra=data.ra
result.dec=data.dec
outdir='./ccds/'
scale=0.2637/3600.0
for i=0,n-1 do begin
	brick=data[i].brickname
	fileccds='./ccds/decals-'+brickname[i]+'-ccds.fits'
	; if ~file_test(fileccds,/read) then begin	
		link='http://portal.nersc.gov/project/cosmo/data/legacysurvey/dr1/coadd/'+strmid(brick,0,3)+'/'+brick+'/decals-'+brick+'-ccds.fits'
		spawn, 'wget -O '+fileccds+' '+link, /HIDE, /LOG_OUTPUT
	; endif
	if ~file_test(fileccds,/read) then begin
		print,'Warning: Get ccds file failed...index='+string(i)+',id='+string(result[i].id)+',brickname='+brick
		;continue
	endif else begin
		da=mrdfits(fileccds,1,/silent)
		index=where(da.filter eq 'z')
		if (min(index) ge 0) then begin
			rac=result[i].ra
			decc=result[i].dec
			da=da[index]
			ra0=da.ra
			dec0=da.dec
			ra_low=ra0-(4094/2.0-da.ccd_y0)*scale
			ra_high=ra0+(da.ccd_y1-4094/2.0)*scale
			dec_low=dec0-(2046/2.0-da.ccd_x0)*scale
			dec_high=dec0+(da.ccd_x1-2046/2.0)*scale

			ra_in=(ra_low-rac)*(ra_high-rac)
			dec_in=(dec_low-decc)*(dec_high-decc)
			index=where((ra_in le 0) and (dec_in le 0))
			if (min(index) ge 0) then begin
				index=index[0]
				result[i].hasimage=1l
				result[i].airmass=da[index].airmass
				result[i].date_obs=da[index].date_obs
				result[i].g_seeing=da[index].g_seeing
				result[i].exptime=da[index].exptime
				result[i].propid=da[index].propid
				result[i].extname=da[index].extname
				result[i].ccdnum=da[index].ccdnum
				result[i].cpimage=da[index].cpimage
				result[i].calname=da[index].calname
			endif else begin
				result[i].hasimage=0l
				result[i].airmass=-1
				result[i].date_obs='null'
				result[i].g_seeing=-1
				result[i].exptime=0
				result[i].propid='null'
				result[i].extname='null'
				result[i].ccdnum=-1
				result[i].cpimage='null'
				result[i].calname='null'
			endelse
		endif else begin
			print,'Warning: No such z image...index='+string(i)+',id='+string(result[i].id)+',brickname='+brick
		endelse
	endelse
endfor
mwrfits,result,'check_ccds.fits'
end
