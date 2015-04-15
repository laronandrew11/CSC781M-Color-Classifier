%   plotLab.m   2015-04-15 
% 
%  This function plots the image in the Lab colorspace
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%  plot = plotLab(Lab);              % Plots the image in the Lab colorspace
%  plot = plotLab(Lab, V, scale);    % Plots the image in the Lab colorspace and draws the principal component axes
%
%      Lab                           % The image in Lab colorspace
%      m                             % The 3x1 mean vector of the input matrix
%      V                             % The eigenvectors which define the principal component axes
%      scale                         % How long the axes will be drawn

function S = plotLab(Lab, m, V, scale) %   Area of a histogram
  if nargin > 0
    figure;
    plot3(Lab(:,:,1), Lab(:,:,2), Lab(:,:,3), 'r.');
    xlabel('L');
    ylabel('a');
    zlabel('b');
    title("Sample image in the CIELab colorspace");
  endif
  
  if nargin == 4
    % (8) Plot the 1st, 2nd, and 3rd principal components
    line1 = line([m(1) - scale * V(1,1) m(1) + scale * V(1,1)], [m(2) - scale * V(2,1) m(2) + scale * V(2,1)],[m(3) - scale * V(3,1) m(3) + scale * V(3,1)]);
    line2 = line([m(1) - scale * V(1,2) m(1) + scale * V(1,2)], [m(2) - scale * V(2,2) m(2) + scale * V(2,2)],[m(3) - scale * V(3,2) m(3) + scale * V(3,2)]);
    line3 = line([m(1) - scale * V(1,3) m(1) + scale * V(1,3)], [m(2) - scale * V(2,3) m(2) + scale * V(2,3)],[m(3) - scale * V(3,3) m(3) + scale * V(3,3)]);
    
    set(line1, 'color', [0 0 1], "linestyle", "--")
    set(line2, 'color', [0 1 0], "linestyle", "--")
    set(line3, 'color', [0 1 1], "linestyle", "--")
  else
    error("plotLab function requires either 1 or 4 parameters. See help plotLab for more details.");
  endif
  axis tight;
endfunction