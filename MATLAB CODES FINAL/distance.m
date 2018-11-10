function dist = distance(Number_MS,PosMS)

% calculate minimum distance between last MS and rest of them
% input:
%   Number_MS ... Number of MS in the simulation
%   PosMS ... Position of MS (MS1 x | MS1 y | MS2 x | MS2 y | ....)

d=zeros(1,Number_MS-1);


for i=1:Number_MS-1
    d(i)=sqrt((PosMS(1,Number_MS)-PosMS(1,i))^2 + (PosMS(2,Number_MS)-PosMS(2,i))^2);
end

dist = min(d);
end