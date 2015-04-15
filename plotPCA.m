%   plotPCA.m   2015-04-15 
% 
%  This function plots the color vectors in new PCA coordinates
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%  plot = plotPCA(PCA);              % Plots the image in the PCA colorspace
%  plot = plotPCA(PCA, V, scale);    % Plots the image in the PCA colorspace and draws the principal component axes
%
%      PCA                           % The image in PCA colorspace
%      V                             % The eigenvectors which define the principal component axes
%      scale                         % How long the axes will be drawn

function S = plotPCA(PCA)            % Plot the image in the PCA coordinate system
  if nargin > 0
    figure;
	plot3(PCA(:,:,1), PCA(:,:,2), PCA(:,:,3), 'r.');
    xlabel('PC1');
    ylabel('PC2');
    zlabel('PC3');
    title("Sample image in the PCA coordinate system");
  else
    error("plotPCA function requires exactly 1 parameter, which is the PCA matrix. See help plotPCA for more details.");
  endif
  axis tight;
endfunction