;+
; Name: selradec
; Purpose: select ra,dec from DECals dr2 tractor catalogs
; History: Feb 16 2016
; Author: Qian Yang, PKU/Steward, qianyang.astro@gmail.com
;-
;-------------------------------------------------------
function selone,filelist
        ; Name: selone
        ; Purpose: give a list of catalogs in a tile, get ra,dec for the tile.
        n=n_elements(filelist)
        result={}
        for i=0,n-1 do begin
                file=filelist[i]
                data=mrdfits(file,1)
                nd=n_elements(data)
                dat=replicate({ra:0.0d,dec:0.0d},nd)
                dat.ra=data.ra
                dat.dec=data.dec
                result=[result,dat]
        endfor
        return,result
end

pro selradec
TractorLoc='/project/projectdirs/cosmo/data/legacysurvey/dr2/tractor/'
TileName='tiles.txt'
spawn,'ls '+TractorLoc+'> '+TileName
readcol,TileName,format='a',tiles
ni=n_elements(tiles)
for i=0,ni-1 do begin
        spawn,'ls '+TractorLoc+tiles[i]+'/tractor*.fits'+' > tractor_tp.txt'
        readcol,'tractor_tp.txt',format='a',files
        dat=selone(files)
        filename='./tractor_radec/tractor_radec_'+tiles[i]+'.fits'
        mwrfits,dat,filename
endfor
end
