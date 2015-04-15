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
leftValleyIdx = 1;
rightValleyIdx = number_of_bins;

% the minimas and maximas acquired from the histogram
maximas = extremes(1:128);
minimas = extremes(129:256);

% find the first valley
for i = 1:number_of_bins
  % skip all non-valleys (mountains)
  if (minimas(i) == 0)
  	continue;
  endif	

  % found left valley
  leftValleyIdx = i;

  % beginning there, find the next valley
  for j = (leftValleyIdx+1):number_of_bins
    % skip all non-valleys (mountains)
  	if(minimas(j) == 0)
      continue;
    endif
  endfor

  % found right valley
  rightValleyIdx = j;


  % Compute area of histogram between these valleys
  Ap = hist_size(NN, leftValleyIdx, rightValleyIdx);

  % Compute fwhm of this mountain
  fwhmValue = fwhm(XX(leftValleyIdx:rightValleyIdx), NN(leftValleyIdx:rightValleyIdx));

  % Avoid division by zero
  if (fwhmValue > 0)
    f = ( Ap / At ) * (100 / fwhmValue);

    % insert into list
    good_mountains = [good_mountains ; f leftValleyIdx rightValleyIdx];
  endif

  % continue to the next mountain beginning at the right valley as the left valley
  i = j;
endfor
mountains=good_mountains;


