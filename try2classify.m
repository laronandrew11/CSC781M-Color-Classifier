%   try2classify.m   2015-04-17
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Given an MxNx3 RGB image, this function performs segmentation and
%  returns an MxN matrix with each cell having a cluster.
%
%  M = rows of the original image
%  N = columns of the original image
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%  [newImgClass, newImgMask] = try2classify(LAB, imgclass, imgm, number_of_bins, depth);
%
%      LAB                          % The original image in the LAB color space
%      imgclass                     % The MxN matrix containing the current results of classification
%      imgm                         % The MxN matrix describing which regions are currently being processed
%      number_of_bins				% The number of bins to be used in the histogram
%	   depth						% A variable taking note of the depth of the recursion

function [newImgClass, newImgMask] = try2classify(LAB, imgclass, imgm, number_of_bins, depth)

% Take note of the size of the original image
M = rows(LAB);
N = columns(LAB);

% Inspect how many color vectors are to be processed (dictated by the mask imgm)
quantity = sum(sum(imgm));

% Display a log message showing the recursion tree
dprintf(depth);
printf("%d\n", quantity);

% Only proceed with classification if there exists color vectors to process
if (quantity > 0)

  % Compute for the mean vector m, and covariance matrix R
  [R, m] = cov3_masked(LAB, imgm);

  % Get the eigenvectors V and eigenvalues D
  [V, D] = eig(R);

  % transform the CIELab coordinates into PCA coordinates
  PCA = LABtoPCA_masked(LAB, imgm, m, V);

  % (Optional) Plot the PCA
  % plotPCA(PCA, V, 150);

  
  
  % =====================
  % = Classification 
  % =====================
  
  % For each principal component c...
  for c = 1:3
  
    % Filter the PCA coordinates
	% Note: that 1e999 is the value set by the mask
    filtered_PCA = [ ];
    s = length(PCA);
    
    for i = 1:M
      for j = 1:N
        if (PCA(i,j,c) != 1e999)
          filtered_PCA = [filtered_PCA PCA(i,j,c)];
        endif
      endfor
    endfor
    
	
    % Use the filtered PCA values to produce three histograms
	% 
	% nnn 		= quantity per bins
	% xxx 		= labels of each bin
	% extremes 	= a 2x1 matrix describing mountains and valleys respectively
    [nnn, xxx, extremes] = hist_detailed(filtered_PCA, number_of_bins, strcat("c", num2str(c), "' of depth ", num2str(depth)));  
    
	
    % Get the size of one histogram step
    step = xxx(2) - xxx(1);
    
    % Find the best mountain, which is the best subregion to classify
    good_mountains = mountain_selector(nnn, xxx, extremes, number_of_bins);

    
	% ====================
	% = Branching
	% ====================
	% = (1) Unimodal;
	% = (2) Noisy; or
	% = (3) Multimodal
	% ====================
	
	if (rows(good_mountains) == 1)
      % There was only one mountain left; UNIMODAL
      % printf("** Unimodal **\n");
      
	  
	  % If all three mountains of the historgrams were found to be unimodal, classify this region
      if (c == 3)
        newCluster = max(max(imgclass)) + 1;
        
        % thresholds for the mountain
        thresholdmin = good_mountains(1, 2);
        thresholdmax = good_mountains(1, 3);
        
        % select the mountain for the region
        % classify mountain
        classified = (PCA(:,:,c) >= xxx(thresholdmin) - step) & (PCA(:,:,c) <= xxx(thresholdmax) + step);
        imgclass = imgclass .+ (newCluster * classified);
        imgm = !imgclass;
      endif
      
	  
	  
    elseif (rows(good_mountains) == 0)
	  % There were no mountains left; NOISY
      % printf("** Noisy **\n");

	  
	  
    elseif (rows(good_mountains) > 1)
	  % There were multiple mountains found; MULTIMODAL
      % printf("** Multimodal **\n");
    
	
	  % Determine the best mountain
      bestmountain = max(good_mountains(:, 1));
      bestindex = find(good_mountains(:, 1) == bestmountain, 1);
	  
	  % Determine the thresholds of the best mountain
      thresholdmin = good_mountains(bestindex, 2);
      thresholdmax = good_mountains(bestindex, 3);
      
	  % (Optional) display the thresholds
      % printf("best mountain - %d to %d\n", thresholdmin, thresholdmax);
      
	  
	  % =================================================
	  % = RECURSION
	  % =================================================
	  % = At this point, we want to classify only a small
	  % = subsection of the mask imgm. This small 
	  % = subsection is called 'region'
	  % =================================================
	  
	  % Detect the region of the best mountain
      region = (PCA(:,:,c) != 1e999) & (PCA(:,:,c) >= xxx(thresholdmin) - step) & (PCA(:,:,c) <= xxx(thresholdmax) + step);
      % Log messages
	  % printf("current - %d, region - %d\n", quantity, sum(sum(region)));
      
      [imgInner, imgmInner] = try2classify(LAB, imgclass, region, number_of_bins, depth + 1);
      
	  % Update the classifications in the imgclass
      for i = 1:M
        for j = 1:N
          if (region(i,j) == 1)
            imgclass(i,j) = imgInner(i,j);
          endif
        endfor
      endfor

	  
	  % =================================================
	  % = RECURSION
	  % =================================================
	  % = After classifying the mountain defined by the 
	  % = region above, we want to classify the ones 
	  % = outside of that region but with respect to the
	  % = current scope of imgm.
	  % = 
	  % = The ones outside of that region is called 
	  % = 'outRegion'
	  % =================================================
      outRegion = imgm .* !(+region);
      [imgOuter, imgmOuter] = try2classify(LAB, imgclass, outRegion, number_of_bins, depth + 1);
    
	
	  % Update the classifications in the imgclass
      for i = 1:M
        for j = 1:N
          if (imgm(i,j) == 1)
            imgclass(i,j) = imgOuter(i,j);
          endif
        endfor
      endfor
      
	  % In the multimodal case, classification is only performed on the first PC.
	  % The second and third PC are not computed; else they will overwrite the
	  % work that the first PC performed.
	  %
	  % Therefore the for loop for each PC must break.
      break;
    endif
	
  endfor
endif

% Update the return values
newImgClass = imgclass;
newImgMask = imgm;

% Log message regarding the tree depth;
% indicate that the recursive call is surfacing
for i = 1:depth
  printf(" ");
endfor
printf("Pop\n");

endfunction