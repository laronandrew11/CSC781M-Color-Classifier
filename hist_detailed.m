%   hist_detailed.m   2015-04-15 
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
function [NN, XX, extremes] = hist_detailed(X, n, hist_title) %   Area of a histogram
%~~~~~~~~~~~~~~~~~~~~~~~~~
	if nargin > 2
      figure;
      [NN, XX] = hist(X, n);
      bar(XX, NN);
      title( strcat("Histogram of ", hist_title) );
      
      hold on;
      extremes = extr(NN);
      pos1 = reshape(cell2mat(extremes(1)),[1,128]);
      valleys1 = reshape(cell2mat(extremes(2)), [1,128]);
      extremes = [pos1 valleys1];
      
      peaks1 = NN .*(+pos1);
      peakgraph1 = bar(XX, peaks1);
      set (peakgraph1, 'facecolor', 'g');
	else
		error("hist_detailed function requires at least 2 parameters. See help hist_detailed for more details.");
	endif
endfunction