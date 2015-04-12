I = imread('sample.png');
[L,a,b] = RGB2Lab(I);

% Plotting
%  plot3(L,a,b,'r.');
%  xlabel('L');
%  ylabel('a');
%  zlabel('b');

mu = mean(I);
Im = bsxfun(@minus, I, mu);
% Covariance = cov(Im);

% Page 805 of paper
% 'Now define a three-dimensional column vector m'
% This is the 'mean vector'

m = [0 ; 0 ; 0];

% Page 805 of paper
% 'and a 3x3 matric R'
% This is the 'covariance matrix of a color vector c in the original orthogonal coordinate system (x, y, z)'
R = [0 0 0; 0 0 0; 0 0 0];