% ========================================================
%   LABtoPCA.m   2015-04-15 
% 
%   "Then we have a linear transformation for transforming 
%    the color vector c from the original coordinate system
%    into a vector c' into the new coordinate system of the
%    principal component axes." (Tominaga, 1990, p. 805)
%
% ========================================================
%  This function transforms color vectors in the CIELab colorspace 
%  into new color vectors in the coordinate system of the PC axes.
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%  PCA = LABtoPCA(Lab, m, V);          % Returns the newly transformed color vectors
%
%      Lab                             % The input image in the Lab colorspace
%      m                               % The 3x1 mean vector of the input matrix
%      V                               % The eigenvectors computed from the covariance matrix
%

function PCA = LABtoPCA(Lab, m, V)     % Computes the PCA
  if nargin == 3
    size = length(Lab);
  
    PCA = zeros(size, size, 3);
  
    for i = 1:size
      for j = 1:size
        cprime = V' * (Lab(i, j) - m);
      
        for k = 1:3
          PCA(i,j,k) = cprime(k);
        endfor
      endfor
    endfor

  else
    error("LABtoPCA is expecting three parameters. See help LABtoPCA for more details.");
  endif
endfunction
