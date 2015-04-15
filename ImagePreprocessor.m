pkg load signal;
close all;

% (1) Read and display the image
I = imread('sample2.png');
% imshow(I);
% title("Original sample image");


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

[c1n, c1x, extremes1] = hist_detailed(PCA(:,:,1)(:), number_of_bins, " c1'");
[c2n, c2x, extremes2] = hist_detailed(PCA(:,:,2)(:), number_of_bins, " c2'");
[c3n, c3x, extremes3] = hist_detailed(PCA(:,:,3)(:), number_of_bins, " c3'");


% Compute total histogram size of c1n
At = hist_size(c1n);

% Container for the mountains and its criteria value
% format is [idx leftvalleyidx rightvalleyidx]
good_mountains = [ ];

% initializations
leftValleyIdx = 1;
rightValleyIdx = number_of_bins;

% the minimas and maximas acquired from the histogram
maximas = extremes1(1:128);
minimas = extremes1(129:256);

% find the first valley
for i = 1:number_of_bins
  % skip all non-valleys (mountains)
  if (minimas(i) == 0)
  	continue;
  endif	

  % found left valley
  leftValleyIdx = i;

  % beginning there, find the next valley
  for j = (leftValleyIdx+1):number_of_bins
    % skip all non-valleys (mountains)
  	if(minimas(j) == 0)
      continue;
    endif
  endfor

  % found right valley
  rightValleyIdx = j;


  % Compute area of histogram between these valleys
  Ap = hist_size(c1n, leftValleyIdx, rightValleyIdx);

  % Compute fwhm of this mountain
  fwhmValue = fwhm(c1x(leftValleyIdx:rightValleyIdx), c1n(leftValleyIdx:rightValleyIdx));

  % Avoid division by zero
  if (fwhmValue > 0)
    f = ( Ap / At ) * (100 / fwhmValue);

    % insert into list
    good_mountains = [good_mountains ; f leftValleyIdx rightValleyIdx];
  endif

  % continue to the next mountain beginning at the right valley as the left valley
  i = j;
endfor





% (12) "A set of significant mountains are determined by taking account
%       of the heights of peaks and valley bottoms, and then a criterion
%       function is computed to select the most significant mountain.
%       We use the function: "