function [newImgClass, newImgMask] = try2classify(LAB, imgclass, imgm, depth)
% Apply the mask
s = length(LAB);

%imshow(mat2gray(imgm));
%title(strcat("Mask at depth ", num2str(depth)));
%imshow(mat2gray(imgm));
%title(strcat("imgm at depth ", num2str(depth)));

for i = 1:depth
  printf(" ");
endfor

% how many values are in the mask?
quantity = sum(sum(imgm));
printf("%d\n", quantity);

if (quantity > 0)

  % get mean vector m, and covariance mat R
  [R, m] = cov3_masked(LAB, imgm);

  % get eigenvectors V and eigenvalues D
  [V, D] = eig(R);

  % transform CIELab -> PCA
  PCA = LABtoPCA_masked(LAB, imgm, m, V);

  % plotPCA(PCA, V, 150);

  for c = 1:3
    % get the histograms
    number_of_bins = 128;
    
    % these are currently unmasked?
    
    filtered_PCA = [ ];
    s = length(PCA);
    
    for i = 1:s
      for j = 1:s
        if (PCA(i,j,c) != 1e999)
          filtered_PCA = [filtered_PCA PCA(i,j,c)];
        endif
      endfor
    endfor
    
    % filtered = length(filtered_PCA)
    [nnn, xxx, extremes] = hist_detailed(filtered_PCA, number_of_bins, strcat("c", num2str(c), "' of depth ", num2str(depth)));  
    
    % get the size of one histogram step
    step = xxx(2) - xxx(1);
    
    % find subregions (mountains)
    good_mountains = mountain_selector(nnn, xxx, extremes, number_of_bins);

    % depending on the number of mountains
    % pass CSC781M
    
    if (rows(good_mountains) == 1)
      % unimodal
      % printf(" unimodal \n");
      
      if (c == 3)
        newCluster = max(max(imgclass)) + 1;
        
        % thresholds for the mountain
        thresholdmin = good_mountains(1, 2);
        thresholdmax = good_mountains(1, 3);
        
        % select the mountain for the region
        % classify mountain
        classified = (PCA(:,:,c) >= xxx(thresholdmin) - step) & (PCA(:,:,c) <= xxx(thresholdmax));
        imgclass = imgclass .+ (newCluster * classified);
        imgm = !imgclass;
      endif
      
    elseif (rows(good_mountains) == 0)
      % printf("  noisy  \n");

    elseif (rows(good_mountains) > 1)
      % printf("  mult ayy modalmao  \n");
    
      bestmountain = max(good_mountains(:, 1));
      bestindex = find(good_mountains(:, 1) == bestmountain, 1);
      thresholdmin = good_mountains(bestindex, 2);
      thresholdmax = good_mountains(bestindex, 3);
      
      % printf("best mountain - %d to %d\n", thresholdmin, thresholdmax);
      
      region = (PCA(:,:,c) != 1e999) & (PCA(:,:,c) >= xxx(thresholdmin) - step) & (PCA(:,:,c) <= xxx(thresholdmax) + step);
      
      % (xxx(thresholdmin) - step)
      % xxx(thresholdmax)
      
      % printf("current - %d, region - %d\n", quantity, sum(sum(region)));
      
      [imgInner, imgmInner] = try2classify(LAB, imgclass, region, depth + 1);
      % printf("I got out\n");
      
      for i = 1:s
        for j = 1:s
          if (region(i,j) == 1)
            imgclass(i,j) = imgInner(i,j);
          endif
        endfor
      endfor

      outRegion = imgm .* !(+region);
      [imgOuter, imgmOuter] = try2classify(LAB, imgclass, outRegion, depth + 1);
    
      for i = 1:s
        for j = 1:s
          if (imgm(i,j) == 1)
            imgclass(i,j) = imgOuter(i,j);
          endif
        endfor
      endfor
      
      break;
      
    endif
  endfor
endif

newImgClass = imgclass;
newImgMask = imgm;

for i = 1:depth
  printf(" ");
endfor
printf("Pop\n");

endfunction