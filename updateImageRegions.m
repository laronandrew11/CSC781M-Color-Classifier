function newImg=updateImageRegions(img, newRegions, region)
 %update img to get the classified regions
  for f=1:rows(img)
    for g=1:columns(img)
      if(region(f,g)==1)
       img(f,g)=newRegions(f,g);
      endif
    endfor
  endfor
  newImg=img;