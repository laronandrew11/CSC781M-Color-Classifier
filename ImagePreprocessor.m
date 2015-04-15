pkg load signal;
close all;

% (1) Read and display the image
I = imread('sample2.png');
imshow(I);
title("Original sample image");


% (2) Convert to CIELab colorspace
LAB = RGB2Lab(I);


% (3) Acquire the mean vector m

%     Page 805 of paper
%     'Now define a three-dimensional column vector m', this is the 'mean vector'

%     Old implementation
%        m = [mean(mean(LAB(:,:,1))) ; mean(mean(LAB(:,:,2))) ; mean(mean(LAB(:,:,3)))];

% New implementation (same result)
%   squeeze 'removes singleton dimensions from X and return the result.'
m = squeeze( mean(mean(LAB)) );


% (4) Acquire the covariance matrix R

%     Page 805 of paper
%     'and a 3x3 matric R', this is the 'covariance matrix of a color vector c in the original orthogonal coordinate system (x, y, z)'

R = [0 0 0; 0 0 0; 0 0 0];

for i = 1:120
  for j = 1:120
    cminusm = LAB(i,j) - m;
    primed = (cminusm * cminusm');
    R = R + primed;
  endfor
endfor
R = R / 14400;

clear cminusm;
clear primed;

% (5) Acquire the eigenvectors V and the eigenvalues D of the covariance matrix R
[V, D] = eig(R);


% (6) Transform the original color vectors in CIELab into the new color vectors of PCA
PCA = zeros(120, 120, 3);

  for i = 1:120
    for j = 1:120
      cprime = V' * (LAB(i, j) - m);
      
      for k = 1:3
        PCA(i,j,k) = cprime(k);
      endfor
    endfor
  endfor

clear cprime;
clear i;
clear j;
clear k;
  
% (7) Plot the image in the CIELab colorspace
plotCIELab = 0;
if plotCIELab == 1
  figure;
  plot3(LAB(:,:,1), LAB(:,:,2), LAB(:,:,3), 'r.');
  xlabel('L');
  ylabel('a');
  zlabel('b');
  title("Sample image in the CIELab colorspace");

% (8) Plot the 1st, 2nd, and 3rd principal components
  scale=50;
  line1 = line([m(1) - scale * V(1,1) m(1) + scale * V(1,1)], [m(2) - scale * V(2,1) m(2) + scale * V(2,1)],[m(3) - scale * V(3,1) m(3) + scale * V(3,1)]);
  line2 = line([m(1) - scale * V(1,2) m(1) + scale * V(1,2)], [m(2) - scale * V(2,2) m(2) + scale * V(2,2)],[m(3) - scale * V(3,2) m(3) + scale * V(3,2)]);
  line3 = line([m(1) - scale * V(1,3) m(1) + scale * V(1,3)], [m(2) - scale * V(2,3) m(2) + scale * V(2,3)],[m(3) - scale * V(3,3) m(3) + scale * V(3,3)]);

  set(line1, 'color', [0 0 1], "linestyle", "--")
  set(line2, 'color', [0 1 0], "linestyle", "--")
  set(line3, 'color', [0 1 1], "linestyle", "--")

  axis tight;
end

 pc1 = PCA(:,:,1);
  pc2 = PCA(:,:,2);
  pc3 = PCA(:,:,3);

% (9) On a different figure, plot transformed image c'
plotTransformedC = 0;
if plotTransformedC == 1
  figure;

 

  plot3(pc1, pc2, pc3, 'r.');
  title("Color vectors after transformation");

  xlabel('PC1');
  ylabel('PC2');
  zlabel('PC3');

  axis tight;
end

clear plotCIELab;
clear plotTransformedC;

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
[c1n, c1x] = hist(pc1(:), number_of_bins);
bar(c1x, c1n);
title("Histogram of c1'");

hold on;
extremes=extr(c1n);
pos1=reshape(cell2mat(extremes(1)),[1,128]);
peaks1=c1n .*(+pos1);
peakgraph1=bar(c1x, peaks1);
set (peakgraph1, 'facecolor', 'g');

figure;
[c2n, c2x] = hist(pc2(:), number_of_bins);
bar(c2x, c2n);
title("Histogram of c2'");


hold on;
extremes=extr(c2n);
pos2=reshape(cell2mat(extremes(1)),[1,128]);
peaks2=c2n .*(+pos2);
peakgraph2=bar(c2x, peaks2);
set (peakgraph2, 'facecolor', 'g');

figure;
[c3n, c3x] = hist(pc3(:), number_of_bins);
bar(c3x, c3n);
title("Histogram of c3'");

hold on;
extremes=extr(c1n);
pos3=reshape(cell2mat(extremes(1)),[1,128]);
peaks3=c3n .*(+pos3);
peakgraph3=bar(c3x, peaks3);
set (peakgraph3, 'facecolor', 'g');




At = count=sum(n(x>0 & x < 1));



% (12) "A set of significant mountains are determined by taking account
%       of the heights of peaks and valley bottoms, and then a criterion
%       function is computed to select the most significant mountain.
%       We use the function: "

