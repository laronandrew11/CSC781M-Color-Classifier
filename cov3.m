%   cov3.m   2015-04-15 
% 
%   Covariance matrix of a 3D matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This function returns a 3x3 covariance matrix computed from a 3D matrix and its mean
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%  cov3(Lab);                  % Returns the 3x3 covariance matrix of the input matrix
%  [m, R] = cov3(Lab);         % Computes for the covariance matrix of Lab 
%
%      Lab                     % The input 3D matrix
%      m                       % The 3x1 mean vector of the input matrix
%      R                       % The 3x3 covariance matrix of the input matrix
%
function [R, m] = cov3(Lab) %   Covariance matrix of a 3D matrix
%~~~~~~~~~~~~~~~~~~~~~~~~~
	if nargin == 1
		% (3) Acquire the mean vector m

		%     Page 805 of paper
		%     'Now define a three-dimensional column vector m', this is the 'mean vector'

		%     Old implementation
		%        m = [mean(mean(Lab(:,:,1))) ; mean(mean(Lab(:,:,2))) ; mean(mean(Lab(:,:,3)))];

		% New implementation (same result)
		%   squeeze 'removes singleton dimensions from X and return the result.'
		m = squeeze( mean(mean(Lab)) );


		% (4) Acquire the covariance matrix R

		%     Page 805 of paper
		%     'and a 3x3 matric R', this is the 'covariance matrix of a color vector c in the original orthogonal coordinate system (x, y, z)'

		R = [0 0 0; 0 0 0; 0 0 0];

		for i = 1:120
		  for j = 1:120
			cminusm = Lab(i,j) - m;
			primed = (cminusm * cminusm');
			R = R + primed;
		  endfor
		endfor
		R = R / 14400;
	else
		error("cov3 function requires exactly 1 parameter, which is the 3D matrix. See help cov3 for more details.");
	endif
endfunction