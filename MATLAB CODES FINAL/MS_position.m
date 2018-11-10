function [PosMSinit] = MS_position(Area_x,Area_y,Number_MS,constrain)

% Generate position of mobile stations
% input:
%   Area_x ... size of simulation area in x coordinate
%   Area_y ... size of simulation area in y coordinate
%   Number_MS ... number of mobile stations
%   constrain ... min and max distance constrains between 2 MS
% output:
%   PosMSinit ... MS1 x | MS1 y | MS2 x | MS2 y | ....


PosMSinit=nan(2,Number_MS);

% generate first MS position
PosMSinit(1,1) = rand*Area_x; 
PosMSinit(2,1) = rand*Area_y;

% generate others MS position
i = 2;
while i <= Number_MS
    PosMSinit(1,i) = rand*(PosMSinit(1,i-1)+constrain(2));
    PosMSinit(2,i) = rand*(PosMSinit(2,i-1)+constrain(2));
    d = distance (i,PosMSinit);
    if d < constrain (2) && d > constrain (1) && PosMSinit(1,i) < Area_x && PosMSinit(2,i) < Area_y
        i = i+1;
    end
end
    
end


