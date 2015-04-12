% Reference
% http://www.bytefish.de/blog/pca_lda_with_gnu_octave/

% Initial data

X = [2 3;3 4;4 5;5 6;5 7;2 1;3 2;4 2;4 3;6 4;7 6];
c = [  1;  1;  1;  1;  1;  2;  2;  2;  2;  2;  2];

% The find function returns a list where the condition is true.
% It tries to find the elements where c == 1 or c == 2, effectively
% dividing the elements of X into c1 and c2, where their c values differ.

c1 = X(find(c==1),:)
c2 = X(find(c==2),:)

figure;

% Begin plotting all data

% How to read plot(...) function
%   plot(c1(:,1), c1(:,2)

%%  What are the parameters?
%%   Param 1 - c1(:,1)
%%   Param 2 - c1(:,2)

%%  How to read ' c1(:,n) '
%%   in the matrix named c1, 
%%   get the value at axis n (1 for x, 2 for y)
%%   of all the elements (represented by the symbol : )

%% 'ro' is the format
%%   it means red circle, and 'go' means green circle

p1 = plot(c1(:,1), c1(:,2), "ro", "markersize",10, "linewidth", 3); hold on;
p2 = plot(c2(:,1), c2(:,2), "go", "markersize",10, "linewidth", 3)

% limit the axes from 0 to 8
xlim([0 8])
ylim([0 8])

title("Raw dataset and its first and second principal components");



% Compute for the mean
mu = mean(X);

% bsxfun
%%  Broadly speaking, smaller arrays are “broadcast” across the 
%%  larger one, until they have a compatible shape.
Xm = bsxfun(@minus, X, mu);

% Compute for the covariance
C = cov(Xm);

% Compute the eigenvectors
[V,D] = eig(C);

% sort eigenvectors desc
[D, i] = sort(diag(D), 'descend');
V = V(:,i);


scale = 5;
pc1 = line([mu(1) - scale * V(1,1) mu(1) + scale * V(1,1)], [mu(2) - scale * V(2,1) mu(2) + scale * V(2,1)]);
pc2 = line([mu(1) - scale * V(1,2) mu(1) + scale * V(1,2)], [mu(2) - scale * V(2,2) mu(2) + scale * V(2,2)]);

set(pc1, 'color', [1 0 0], "linestyle", "--")
set(pc2, 'color', [0 1 0], "linestyle", "--")


figure;
% project on pc1
z = Xm*V(:,1);
% and reconstruct it
p = z*V(:,1)';
p = bsxfun(@plus, p, mu);

% delete old plots
y1 = p(find(c==1),:);
y2 = p(find(c==2),:);

p1 = plot(y1(:,1),y1(:,2),"ro", "markersize", 10, "linewidth", 3); hold on;
p2 = plot(y2(:,1), y2(:,2),"go", "markersize", 10, "linewidth", 3); 

title("Dataset projected on first principal component");

pc1 = line([mu(1) - scale * V(1,1) mu(1) + scale * V(1,1)], [mu(2) - scale * V(2,1) mu(2) + scale * V(2,1)]);
pc2 = line([mu(1) - scale * V(1,2) mu(1) + scale * V(1,2)], [mu(2) - scale * V(2,2) mu(2) + scale * V(2,2)]);

set(pc1, 'color', [1 0 0], "linestyle", "--")
set(pc2, 'color', [0 1 0], "linestyle", "--")

xlim([0 8])
ylim([0 8])

figure;

% project on pc1
z = Xm*V(:,2);
% and reconstruct it
p = z*V(:,2)';
p = bsxfun(@plus, p, mu);

% delete old plots
y1 = p(find(c==1),:);
y2 = p(find(c==2),:);

p1 = plot(y1(:,1),y1(:,2),"ro", "markersize", 10, "linewidth", 3); hold on;
p2 = plot(y2(:,1), y2(:,2),"go", "markersize", 10, "linewidth", 3); 

title("Dataset projected on second principal component");

pc1 = line([mu(1) - scale * V(1,1) mu(1) + scale * V(1,1)], [mu(2) - scale * V(2,1) mu(2) + scale * V(2,1)]);
pc2 = line([mu(1) - scale * V(1,2) mu(1) + scale * V(1,2)], [mu(2) - scale * V(2,2) mu(2) + scale * V(2,2)]);

set(pc1, 'color', [1 0 0], "linestyle", "--")
set(pc2, 'color', [0 1 0], "linestyle", "--")

xlim([0 8])
ylim([0 8])