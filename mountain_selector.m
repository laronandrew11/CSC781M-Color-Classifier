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

% the minimas and maximas acquired from the histogram
maximas = [0 extremes(1:number_of_bins) 0];
minimas = [1 extremes((number_of_bins+1):(number_of_bins*2)) 1];

% find the first valley
i = 1;

NN = [0 NN 0];
step = XX(2) - XX(1);
XX = [(XX(1) - step) XX (XX(number_of_bins)+step)];


% Only after padding it should the local variable 'number of bins' be incremented
padded_number_of_bins = number_of_bins + 2;
leftValleyIdx = 1;
rightValleyIdx = padded_number_of_bins;

    
while(i < padded_number_of_bins)
  hasMountain = 0;
  
  % skip all non-valleys (mountains)
  if (minimas(i) == 0)
  	continue;
  endif	

  % found left valley
  leftValleyIdx = i;
  % printf("Left valley found: %d\n", i);
  % beginning there, find the next valley
  for j = (leftValleyIdx+1):padded_number_of_bins
    if (maximas(j) != 0)
      % printf("Mountain found: %d\n", j);
      hasMountain = j;
    endif;
    
    % skip all non-valleys (mountains)
  	if(minimas(j) == 0)
      continue;
	  elseif (minimas(j) == 1 && hasMountain == 0)
      leftValleyIdx = j;
      % printf("Left valley updated: %d\n", j);
    elseif (hasMountain != 0)
      % printf("Right valley found: %d\n", j);
	    break;
    endif
  endfor
  
  % found right valley
  rightValleyIdx = j;
  
  
  % Compute area of histogram between these valleys
  
  if (hasMountain != 0)
    % printf("Mountain at [%d] [%d] [%d]\n", leftValleyIdx, hasMountain, rightValleyIdx);
  
    Ap = hist_size(NN', leftValleyIdx, rightValleyIdx);
    
    % Compute fwhm of this mountain
    fwhmValue = fwhm(XX(leftValleyIdx:rightValleyIdx), NN(leftValleyIdx:rightValleyIdx));

    if(At==0)
      printf("At is 0\n");
     endif
    
    % Avoid division by zero
    if (fwhmValue > 0&&At>0)
      f = ( Ap / At ) * (100 / fwhmValue);

      
      % insert into list
    else
      % printf("fwhm was found to be zero\n\n");
      f = 0;
    endif
    
    leftValleyIdx = leftValleyIdx - 1;
    if (leftValleyIdx <= 0)
      leftValleyIdx = 1;
    endif;
    
    rightValleyIdx = rightValleyIdx - 1;
    if (rightValleyIdx >= number_of_bins)
      rightValleyIdx = number_of_bins;
    endif;
    
    good_mountains = [good_mountains ; f leftValleyIdx rightValleyIdx];
  endif

  % continue to the next mountain beginning at the right valley as the left valley
  % printf("Looking for valleys starting at %d\n", j);
  i = j;
endwhile
mountains=good_mountains;