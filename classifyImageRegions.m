function [newRegionIndex, newImg, newImgm, newLAB] = classifyImageRegions(regionIndeximg, imgm,LAB)

  % (3) Acquire the mean vector m and (4) acquire the covariance matrix R
[R, m] = cov3(LAB);

% (5) Acquire the eigenvectors V and the eigenvalues D of the covariance matrix R
[V, D] = eig(R);


% (6) Plot the image in the CIELab colorspace and (7) plot the 1st, 2nd, and 3rd principal components 
scale = 75;
% plotLab(LAB, m, V, scale);

% (8) Transform the original color vectors in CIELab into the new color vectors of PCA
PCA = LABtoPCA(LAB, m, V);


% (9) On a different figure, plot transformed image c', in the PCA coordinate system
% plotPCA(PCA);


% (10)  "First we initialize a color label array img(i, j )"
img = zeros(120,120);

%       "and a mask array imgm(i, j)"
imgm = ones(120,120);
%        This mask array determines whether an image pixel 
%        is still considered to be part of the data set 
%        for cluster detection, or whether it has already
%        been classified.

% (11) "compute the histograms of the color features c1, c2, and c3, one by one."

number_of_bins = 128;

[c1n, c1x, extremes1] = hist_detailed(PCA(:,:,1)(:), number_of_bins, " c1'");
[c2n, c2x, extremes2] = hist_detailed(PCA(:,:,2)(:), number_of_bins, " c2'");
[c3n, c3x, extremes3] = hist_detailed(PCA(:,:,3)(:), number_of_bins, " c3'");


good_mountains=mountain_selector(c1n', c1x, number_of_bins);


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

if (rows(good_mountains)>1)
 bestmountain=max(good_mountains(:,1));
 bestindex = find(good_mountains(:,1)==bestmountain,1);
 thresholdmin=good_mountains(bestindex,2);
 thresholdmax=good_mountains(bestindex,3);
 %%assuming that program will then consider all regions outside the most significant mountain
 %%check all values in PC1 matrix. If they fall between min and max thresholds, set the value with the same index in imgm to 0.
 region = (PCA(:,:,1)<thresholdmin)|(PCA(:,:,1)>thresholdmax);
 imgm=imgm.*(+region);
 classifyImageRegions(img, imgm, LAB);
endif


% (14) "In a second case, if the first histogram is noisy and has no 
% 		well-defined peaks, then it meets the dosing condition of the
% 		sequential color classification. The remaining pixels without l i ~
% 		bels become too sparse to create a cluster in the color space. The
% 		finishing process is executed.
if (rows(good_mountains)==0)
  newImg=img;
  newImgm=imgm;
  newLAB=LAB;
endif


% (15) "In the third case, one of the histograms is unimodal. If the 
%       first histogram is unimodal, the succeeding second and third
%       histograms are analyzed. If all histograms are unimodal, then we
%       extract the color data which are decided to belong to one color
%       cluster. The extracted pixels are labeled on  img(i,  j). Detection
%       of a color cluster ends. If no region without color labels remains,
%       then the finishing process is executed.

regionIndex=0;
if (rows(good_mountains)==1)
  good_mountains2=mountain_selector(c2n, c2x, extremes2, number_of_bins);
   good_mountains3=mountain_selector(c3n, c3x, extremes3, number_of_bins);
  if (rows(good_mountains2)==1 &(rows(good_mountains3)==1))%%if 2nd and 3rd histograms are unimodal, mark region on img.
    %%TODO extract color data
    %%find the position of each pixel in the region and change its value in image map
    img(i,j)=regionIndex;
    imgm(i,j)=0;
    regionIndex+=1;
  endif
endif