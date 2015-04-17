function [R, m] = cov3_masked(Lab, mask) %   Covariance matrix of a 3D matrix
	
  if nargin == 2
    
    m = [0; 0; 0];
    count = sum(sum(mask));
    size = length(Lab);

    % sorry for imperatively coding this
    % calculating mean vector
    for i = 1:size
      for j = 1:size
        for k = 1:3
          if mask(i,j) == 1
            m(k) = m(k) + Lab(i,j,k);
          endif
        endfor
      endfor
    endfor
    
    % mean is basically addding everything in the mask
    % then dividing them by the amount of the elements in it
    
    m = m ./ count;
    
    R = zeros(3,3);
    
    % calculating covariance matrix R
    for i = 1:size
      for j = 1:size
        if mask(i,j) == 1
          cminusm = Lab(i,j) - m;
          primed = (cminusm * cminusm');
          R = R + primed;
        endif
      endfor
    endfor
    
    R = R ./ count;
	endif
endfunction
  