pkg load signal;
close all;

% (1) Read and display the image
I = imread('sample1.png');
imshow(I);
title("Original sample image");


% (2) Convert to CIELab colorspace
LAB = RGB2Lab(I);

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

figure;
[c1n, c1x] = hist(PCA(:,:,1)(:), number_of_bins);
bar(c1x, c1n);
title("Histogram of c1'");

figure;
[c2n, c2x] = hist(PCA(:,:,2)(:), number_of_bins);
bar(c2x, c2n);
title("Histogram of c2'");

figure;
[c3n, c3x] = hist(PCA(:,:,3)(:), number_of_bins);
bar(c3x, c3n);
title("Histogram of c3'");

% Extremes=extr(hist1);


% (12) "A set of significant mountains are determined by taking account
%       of the heights of peaks and valley bottoms, and then a criterion
%       function is computed to select the most significant mountain.
%       We use the function: "

