function [v2c, rect, p02]  = loadCalibration(filename)

% open file
fid = fopen(filename,'r');

if fid<0
  error(['ERROR: Could not load: ' filename]);
end

% read calibration
v2c = [ readVariable(fid, 'Tr_velo_to_cam',3,4) ; 0 0 0 1 ] ;
p02 = readVariable(fid, 'P2',3,4); 
rect = eye(4) ;
rect(1:3,1:3) =  readVariable(fid, 'R0_rect',3,3); ;

% close file
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function A = readVariable(fid,name,M,N)

% rewind
fseek(fid,0,'bof');

% search for variable identifier
success = 1;
while success>0
  [str,success] = fscanf(fid,'%s',1);
  if strcmp(str,[name ':'])
    break;
  end
end

% return if variable identifier not found
if ~success
  A = [];
  return;
end

% fill matrix
A = zeros(M,N);
for m=1:M
  for n=1:N
    [val,success] = fscanf(fid,'%f',1);
    if success
      A(m,n) = val;
    else
      A = [];
      return;
    end
  end
end
