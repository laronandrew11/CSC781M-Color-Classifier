close all;

I = imread('sample.png');
[L,a,b] = RGB2Lab(I);

% Plotting
%  plot3(L,a,b,'r.');
%  xlabel('L');
%  ylabel('a');
%  zlabel('b');

mu = mean(I);
Im = bsxfun(@minus, I, mu);

% Darren: Not sure if this is right.
%  What I did was obtain the covariance through auto-correlation
%  on separate channels (L, a, and b) and placed them in a vector.

covOfL = cov(Im(:,:,1));
covOfA = cov(Im(:,:,2));
covOfB = cov(Im(:,:,3));

[VL,DL] = eig(covOfL);
[Va,Da] = eig(covOfA);
[Vb,Db] = eig(covOfB);

% Sort eigenvectors in descending manner so that the first one is the first principal component
[DL, i] = sort(diag(DL), 'descend');
VL = VL(:,i);

[Da, i] = sort(diag(Da), 'descend');
Va = Va(:,i);

[Db, i] = sort(diag(Db), 'descend');
Vb = Vb(:,i);


scale = 25600;

% Plotting
% Line reference - http://octave.sourceforge.net/octave/function/line.html
p1 = plot(L(:,1), L(:,2), "ro", "markersize",10, "linewidth", 3);

pc1L = line([mu(1) - scale * VL(1,1) mu(1) + scale * VL(1,1)], [mu(2) - scale * VL(2,1) mu(2) + scale * VL(2,1)]);
pc2L = line([mu(1) - scale * VL(1,2) mu(1) + scale * VL(1,2)], [mu(2) - scale * VL(2,2) mu(2) + scale * VL(2,2)]);
set(pc1L, 'color', [1 0 0], "linestyle", "--")
set(pc2L, 'color', [0 1 0], "linestyle", "--")

% Limits are from -128 to 128
% Reference - http://en.wikipedia.org/wiki/Lab_color_space
xlim([-128 128])
ylim([-128 128])

figure;
p2 = plot(a(:,1), a(:,2), "go", "markersize",10, "linewidth", 3);

pc1a = line([mu(1) - scale * Va(1,1) mu(1) + scale * Va(1,1)], [mu(2) - scale * Va(2,1) mu(2) + scale * Va(2,1)]);
pc2a = line([mu(1) - scale * Va(1,2) mu(1) + scale * Va(1,2)], [mu(2) - scale * Va(2,2) mu(2) + scale * Va(2,2)]);
set(pc1a, 'color', [1 0 0], "linestyle", "--")
set(pc2a, 'color', [0 1 0], "linestyle", "--")
xlim([-128 128])
ylim([-128 128])

figure;
p3 = plot(b(:,1), b(:,2), "bo", "markersize",10, "linewidth", 3);

pc1b = line([mu(1) - scale * Vb(1,1) mu(1) + scale * Vb(1,1)], [mu(2) - scale * Vb(2,1) mu(2) + scale * Vb(2,1)]);
pc2b = line([mu(1) - scale * Vb(1,2) mu(1) + scale * Vb(1,2)], [mu(2) - scale * Vb(2,2) mu(2) + scale * Vb(2,2)]);
set(pc1b, 'color', [1 0 0], "linestyle", "--")
set(pc2b, 'color', [0 1 0], "linestyle", "--")
xlim([-128 128])
ylim([-128 128])


% Page 805 of paper
% 'Now define a three-dimensional column vector m'
% This is the 'mean vector'

m = [0 ; 0 ; 0];

% Page 805 of paper
% 'and a 3x3 matric R'
% This is the 'covariance matrix of a color vector c in the original orthogonal coordinate system (x, y, z)'
R = [0 0 0; 0 0 0; 0 0 0];