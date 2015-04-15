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
function mountains= mountain_selector(NN, XX, number_of_bins) %   Area of a histogram
%~~~~~~~~~~~~~~~~~~~~~~~~~
% Compute total histogram size of c1n
At = hist_size(NN);

% Container for the mountains and its criteria value
% format is [idx leftvalleyidx rightvalleyidx]
good_mountains = [ ];

% initializations
leftValleyIdx = 1;
rightValleyIdx = number_of_bins;

[pks, idx] = findpeaks(NN);
figure;
plot(XX, NN, XX(idx), NN(idx), ".m");
title("Mountains");

% the minimas and maximas acquired from the histogram

mountains = [pks, idx];
