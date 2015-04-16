%   mountain_selector.m   2015-04-15 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This function returns the size of a histogram.
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%  S = hist_detailed(X, n);      % Returns the area of histogram given the number of elements
%
%      X                         % The data to count
%      n                         % The number of bins in the histogram
%
function mountains= mountain_selector(NN, XX, extremes, number_of_bins) %   Area of a histogram
%~~~~~~~~~~~~~~~~~~~~~~~~~
% Compute total histogram size of c1n
At = hist_size(NN);

% Container for the mountains and its criteria value
% format is [idx leftvalleyidx rightvalleyidx]
good_mountains = [ ];

% initializations
number_of_bins = number_of_bins + 2;
leftValleyIdx = 1;
rightValleyIdx = number_of_bins;

% the minimas and maximas acquired from the histogram
maximas = [0 extremes(1:128) 0];
minimas = [1 extremes(129:256) 1];

% find the first valley
i = 1;
while(i < number_of_bins)
  hasMountain = 0;
  
  % skip all non-valleys (mountains)
  if (minimas(i) == 0)
  	continue;
  endif	

  % found left valley
  leftValleyIdx = i;
  % printf("Left valley found: %d\n", i);
  % beginning there, find the next valley
  for j = (leftValleyIdx+1):number_of_bins
    if (maximas(j) == 1)
      % printf("Mountain found: %d\n", j);
      hasMountain = 1;
    endif;
    
    % skip all non-valleys (mountains)
  	if(minimas(j) == 0)
      continue;
	  elseif (minimas(j) == 1 && hasMountain == 0)
      leftValleyIdx = j;
      % printf("Left valley updated: %d\n", j);
    elseif (hasMountain == 1)
      % printf("Right valley found: %d\n", j);
	    break;
    endif
  endfor
  
  % found right valley
  rightValleyIdx = j;
  
  NN = [0 NN 0];
  XX = [XX(1) XX XX(128)];
  
  % Compute area of histogram between these valleys
  Ap = hist_size(NN', leftValleyIdx, rightValleyIdx);

  % Compute fwhm of this mountain
  fwhmValue = fwhm(XX(leftValleyIdx:rightValleyIdx), NN(leftValleyIdx:rightValleyIdx));

  % Avoid division by zero
  if (fwhmValue > 0)
    f = ( Ap / At ) * (100 / fwhmValue);

    % insert into list
    good_mountains = [good_mountains ; f leftValleyIdx rightValleyIdx];
  endif

  % continue to the next mountain beginning at the right valley as the left valley
  % printf("Looking for valleys starting at %d\n", j);
  i = j;
endwhile
mountains=good_mountains;