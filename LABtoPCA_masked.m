function PCA = LABtoPCA_masked(Lab, mask, m, V)     % Computes the PCA
  if nargin == 4
  
    size = length(Lab);  
    PCA = zeros(size, size, 3);
  
    for i = 1:size
      for j = 1:size
        if mask(i,j) != 0
          cprime = V' * (Lab(i, j) - m);
        
          for k = 1:3
            PCA(i,j,k) = cprime(k);
          endfor
        else
          PCA(i,j,1) = 1e999;
          PCA(i,j,2) = 1e999;
          PCA(i,j,3) = 1e999;
        endif
      endfor
    endfor

  endif
endfunction