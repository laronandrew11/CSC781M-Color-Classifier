close all;

I = imread('sample1.png');
LAB = RGB2Lab(I);



% Plotting
%  plot3(L,a,b,'r.');
%  xlabel('L');
%  ylabel('a');
%  zlabel('b');


% Page 805 of paper
% 'Now define a three-dimensional column vector m'
% This is the 'mean vector'

m = [mean(mean(LAB(:,:,1))) ; mean(mean(LAB(:,:,2))) ; mean(mean(LAB(:,:,3)))];


% Page 805 of paper
% 'and a 3x3 matric R'
% This is the 'covariance matrix of a color vector c in the original orthogonal coordinate system (x, y, z)'

% Im = bsxfun(@minus, I, mu);

E = [0 0 0; 0 0 0; 0 0 0];
for i = 1:120
  for j = 1:120
    cminusm = LAB(i,j) - m;
    primed = (cminusm * cminusm');
    E = E + primed;
  endfor
endfor
E = E / 14400;
 
[V, D] = eig(E);

PCA = zeros(120, 120, 3);

  for i = 1:120
    for j = 1:120
      cprime = V' * (LAB(i, j) - m);
      
      for k = 1:3
        PCA(i,j,k) = cprime(k);
      endfor
    endfor
  endfor
  
mean(mean(PCA(:,:,1)))
mean(mean(PCA(:,:,2)))
mean(mean(PCA(:,:,3)))


%%trying to plot PCA vectors on LAB space




plot3(LAB(:,:,1), LAB(:,:,2), LAB(:,:,3), 'r.');
xlabel('L');
ylabel('a');
zlabel('b');
scale=75;

line1 = line([m(1) - scale * V(1,1) m(1) + scale * V(1,1)], [m(2) - scale * V(2,1) m(2) + scale * V(2,1)],[m(3) - scale * V(3,1) m(3) + scale * V(3,1)]);
line2 = line([m(1) - scale * V(1,2) m(1) + scale * V(1,2)], [m(2) - scale * V(2,2) m(2) + scale * V(2,2)],[m(3) - scale * V(3,2) m(3) + scale * V(3,2)]);
line3 = line([m(1) - scale * V(1,3) m(1) + scale * V(1,3)], [m(2) - scale * V(2,3) m(2) + scale * V(2,3)],[m(3) - scale * V(3,3) m(3) + scale * V(3,3)]);


set(line1, 'color', [0 0 1], "linestyle", "--")
set(line2, 'color', [0 1 0], "linestyle", "--")
set(line3, 'color', [0 1 1], "linestyle", "--")

axis tight;


pc1 = PCA(:,:,1);
pc2 = PCA(:,:,2);
pc3 = PCA(:,:,3);


figure;
plot3(pc1, pc2, pc3, 'r.');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');


% E = E / 14400;
 
% cminusm_L = LAB(:,:,1) - m(1);
% cminusm_a = LAB(:,:,2) - m(2);
% cminusm_b = LAB(:,:,3) - m(3);


% Darren: Not sure if this is right.
%  What I did was obtain the covariance through auto-correlation
%  on separate channels (L, a, and b) and placed them in a vector.

 %covOfL = cov(LAB(:,:,1));
 %covOfA = cov(LAB(:,:,2));
 %covOfB = cov(LAB(:,:,3));

% [VL,DL] = eig(covOfL);
% [Va,Da] = eig(covOfA);
% [Vb,Db] = eig(covOfB);

% Sort eigenvectors in descending manner so that the first one is the first principal component
% [DL, i] = sort(diag(DL), 'descend');
% VL = VL(:,i);

% [Da, i] = sort(diag(Da), 'descend');
% Va = Va(:,i);

% [Db, i] = sort(diag(Db), 'descend');
% Vb = Vb(:,i);


% scale = 25600;

% Plotting
% Line reference - http://octave.sourceforge.net/octave/function/line.html
% p1 = plot(L(:,1), L(:,2), "ro", "markersize",10, "linewidth", 3);

% pc1L = line([mu(1) - scale * VL(1,1) mu(1) + scale * VL(1,1)], [mu(2) - scale * VL(2,1) mu(2) + scale * VL(2,1)]);
% pc2L = line([mu(1) - scale * VL(1,2) mu(1) + scale * VL(1,2)], [mu(2) - scale * VL(2,2) mu(2) + scale * VL(2,2)]);
% set(pc1L, 'color', [1 0 0], "linestyle", "--")
% set(pc2L, 'color', [0 1 0], "linestyle", "--")

% Limits are from -128 to 128
% Reference - http://en.wikipedia.org/wiki/Lab_color_space
% xlim([-128 128])
% ylim([-128 128])

% figure;
% p2 = plot(a(:,1), a(:,2), "go", "markersize",10, "linewidth", 3);

% pc1a = line([mu(1) - scale * Va(1,1) mu(1) + scale * Va(1,1)], [mu(2) - scale * Va(2,1) mu(2) + scale * Va(2,1)]);
% pc2a = line([mu(1) - scale * Va(1,2) mu(1) + scale * Va(1,2)], [mu(2) - scale * Va(2,2) mu(2) + scale * Va(2,2)]);
% set(pc1a, 'color', [1 0 0], "linestyle", "--")
% set(pc2a, 'color', [0 1 0], "linestyle", "--")
% xlim([-128 128])
% ylim([-128 128])

% figure;
% p3 = plot(b(:,1), b(:,2), "bo", "markersize",10, "linewidth", 3);
% 
% pc1b = line([mu(1) - scale * Vb(1,1) mu(1) + scale * Vb(1,1)], [mu(2) - scale * Vb(2,1) mu(2) + scale * Vb(2,1)]);
% pc2b = line([mu(1) - scale * Vb(1,2) mu(1) + scale * Vb(1,2)], [mu(2) - scale * Vb(2,2) mu(2) + scale * Vb(2,2)]);
% set(pc1b, 'color', [1 0 0], "linestyle", "--")
% set(pc2b, 'color', [0 1 0], "linestyle", "--")
% xlim([-128 128])
% ylim([-128 128])





%R = [0 0 0; 0 0 0; 0 0 0];