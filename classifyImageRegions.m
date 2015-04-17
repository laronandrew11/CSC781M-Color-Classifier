function [newImg, newImgm] = classifyImageRegions(img, imgm, LAB, iterationNo)
printf("*****DEPTH %d **********\n",iterationNo);
% Apply the mask
maskedLab = zeros(120, 120, 3);
for i = 1:120
  for j = 1:120
    for k = 1:3
    
     % if LAB(i,j,k) == 0
        %printf("A zero!\n");
      %endif
  
     bigMask=!imgm;
     bigMask.*1.0e009;
    bigMask=bigMask+1;
      
     %maskedLab(i,j,k) = imgm(i,j) * LAB(i,j,k);
     maskedLab(i,j,k) = bigMask(i,j) .* LAB(i,j,k);
    endfor
  endfor
endfor

% maskedLab = LAB;

printf("Mask will process %d values.\n\n", sum(sum(imgm)));

% (3) Acquire the mean vector m and (4) acquire the covariance matrix R
[R, m] = cov3(maskedLab);

% (5) Acquire the eigenvectors V and the eigenvalues D of the covariance matrix R
[V, D] = eig(R);

% (6) Plot the image in the CIELab colorspace and (7) plot the 1st, 2nd, and 3rd principal components 
% scale = 75;
% plotLab(LAB, m, V, scale);

% (8) Transform the original color vectors in CIELab into the new color vectors of PCA
PCA = LABtoPCA(maskedLab, m, V);

% (9) On a different figure, plot transformed image c', in the PCA coordinate system
% plotPCA(PCA);

% (11) "compute the histograms of the color features c1, c2, and c3, one by one."
number_of_bins = 128;

[c1n, c1x, extremes1] = hist_detailed(PCA(:,:,1)(:), number_of_bins, " c1'");
[c2n, c2x, extremes2] = hist_detailed(PCA(:,:,2)(:), number_of_bins, " c2'");
[c3n, c3x, extremes3] = hist_detailed(PCA(:,:,3)(:), number_of_bins, " c3'");


classes = [c1n, c1x, extremes1;
           c2n, c2x, extremes2;
           c3n, c3x, extremes3];
           
for c = 1:3
  
% (12) "A set of significant mountains are determined by taking account
%       of the heights of peaks and valley bottoms, and then a criterion
%       function is computed to select the most significant mountain.
%       We use the function: "


% (13) In one case, if a histogram is multimodal, the most signifi-
%      can't mountain in the histogram is selected. A pair of thresholds
%      is determined as the color features corresponding to two valleys
%      at the sides of the mountain. The image is split using the thresh-
%      olds. A mask for describing the extracted subregions is created
%      on imgm(i, j). We further continue with cluster detection with
%      respect to these subregions.
nnn = classes(c,1:128);
xxx = classes(c,129:256);

step = xxx(2) - xxx(1);

  good_mountains = mountain_selector(nnn, xxx, classes(c,257:512), number_of_bins);

if (rows(good_mountains) > 1)
  printf("Hey it's multimodal (%d)!\n\n", c);
  bestmountain = max(good_mountains(:, 1));
  bestindex = find(good_mountains(:, 1) == bestmountain, 1);
  thresholdmin = good_mountains(bestindex, 2);
  thresholdmax = good_mountains(bestindex, 3);
  
  bestmountain
  bestindex
  thresholdmin
  thresholdmax
  %%assuming that program will then consider all regions outside the most significant mountain
  %%check all values in PC1 matrix. If they fall between min and max thresholds, set the value with the same index in imgm to 0.
  
%  (xxx(thresholdmin) - step)
%  xxx(thresholdmax)
%  PCA(:,:,c)
  
  
  region = (PCA(:,:,c) <= xxx(thresholdmin) - step) | (PCA(:,:,c) >= xxx(thresholdmax));
  
  imgm = imgm .* (+region);
  
 % region
  
 [b,c] = classifyImageRegions(img, imgm, LAB, iterationNo+1);
 
 img = b;
 imgm = c;
 
% (14) "In a second case, if the first histogram is noisy and has no 
% 		well-defined peaks, then it meets the dosing condition of the
% 		sequential color classification. The remaining pixels without l i ~
% 		bels become too sparse to create a cluster in the color space. The
% 		finishing process is executed.
elseif (rows(good_mountains) == 0)
  printf("Hey it's noisy (%d)!\n\n", c);
  newImg = img;
  newImgm = imgm;
  newLAB = LAB;

% (15) "In the third case, one of the histograms is unimodal. If the 
%       first histogram is unimodal, the succeeding second and third
%       histograms are analyzed. If all histograms are unimodal, then we
%       extract the color data which are decided to belong to one color
%       cluster. The extracted pixels are labeled on  img(i,  j). Detection
%       of a color cluster ends. If no region without color labels remains,
%       then the finishing process is executed.


elseif (rows(good_mountains) == 1)
  printf("Hey it's unimodal (%d)!\n\n", c);
  if (c == 3)
    prevCluster = regionIndex = max(max(img));
    printf(" ** The previous cluster is %d **\n", prevCluster);
    regionIndex = prevCluster + 1;
    
    thresholdmin = good_mountains(1, 2);
    thresholdmax = good_mountains(1, 3);
    
    region = (PCA(:,:,c) <= xxx(thresholdmin) - step) | (PCA(:,:,c) >= xxx(thresholdmax));
    imgm = imgm .* (+region);
    
   %  region
    
    for i = 1:120
      for j = 1:120
          if region(i,j) == 0
            img(i,j) = regionIndex;
          endif
       endfor
    endfor
    if(sum(imgm)==0)
      newImg = img;
      newImgm = imgm;
     endif
  endif
  
endif
endfor

