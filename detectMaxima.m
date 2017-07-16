% function that looks for the N strongest values in a 2D matrix F
% Return values:
% x,y,maxVals - vectors with nrMaxima entries representing the x/y position and strength of each found maximum
% parameters:
% F - a 2D matrix of doubles
% nrMaxima - how many maxima shall be found?
% boxSize - how large is the area around each found maximum that should be erased?
%
function  [x,y,maxVals] = detectMaxima(F, nrMaxima, boxSize)

  x = zeros(1,nrMaxima) ;
  y = zeros(1,nrMaxima) ;
  maxVals = zeros(1,nrMaxima) ;

  %For each index found in FF, calculate the appropriate indices in F.
  h = size(F,1);
  F_min = min(F(:));
  for n = 1:nrMaxima
      %Find the maximum
      FF = F(:);%make a vector out of F
      [sorted_FF, sorted_index] = sort(FF,'descend');%sort it in descendent order
      maxVals(n) = sorted_FF(1);
      FF_index = sorted_index(1);

      %Pay attention to the fact x and y are respectively height and width
      %of the matrix because of the strange axis of the image
      x(n)= floor(FF_index/h) + 1;
      y(n)= FF_index -((x(n)-1)*h);

      % erase the area around the maximum
      y_min = round( max(1,         max_row - boxSize/2));
      y_max = round( min(size(F,1), max_row + boxSize/2)) ;
      x_min = round( max(1,         max_col - boxSize/2));
      x_max = round( min(size(F,2), max_col + boxSize/2));

      F(y_min:y_max, x_min:x_max) = F_min;
  end

end
