%   hist_size.m   2015-04-15 
% 
%   Area of a histogram
%   Reference - http://www.mathworks.com/matlabcentral/newsreader/view_thread/92758
%   Extended by Darren
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This function returns the size of a histogram.
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%  S = hist_size(NN);          % Returns the area of histogram given the number of elements
%  S = hist_size(NN, a, b);    % Returns the area of histogram beginning from bins 'a' to 'b'
%
%      NN                      % Numbers of elements, produced by the 'hist' function
%      a, b                    % Markers for which bins to begin counting from
%
function S = hist_size(NN, a, b) %   Area of a histogram
%~~~~~~~~~~~~~~~~~~~~~~~~~
	if nargin == 3
		S = sum(NN(a:b));
	elseif nargin == 1
		S = sum(NN(:));
	else
		error("hist_size function requires either 1 or 3 parameters. See help hist_size for more details.");
	endif
endfunction