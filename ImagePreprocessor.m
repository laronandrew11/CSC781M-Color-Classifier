pkg load image;
pkg load signal;
close all;

% 		Read image
I = imread('sample.png');

% 		(optional) Display the image 

% imshow(I);
% title("Original sample image");

% 		Convert image from RGB color space to CIELab color space
LAB = RGB2Lab(I);

%       "First, initialize a color label array img(i, j )"
img = zeros(120,120);

%       "and a mask array imgm(i, j)"
%		1 for 'to be classified' and 0 for 'finished classification'
imgm = ones(120,120);

%		Specify the number of bins in the histogram
number_of_bins = 50;

% 		Perform recursive classification"
%		  -> LAB to PCA
%		  -> Histogram of each principal component
%		  -> Analyze histogram (multimodal, unimodal, or noisy)
%		  -> Recurse if multimodal, classify if unimodal
[b, c] = try2classify(LAB, img, imgm, number_of_bins, 0);

% 		Update the image and the image mask
img = b;
imgm = c;

%		How many clusters were detected?
m = max(max(img));

%		Color the clusters in varying grayscale values
if (m == 0)
  img = img ./ m;
endif

%		Present the segmented image
imshow(mat2gray(img));
title(strcat("Segmentation results"));
