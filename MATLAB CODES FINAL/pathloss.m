function PL = pathloss(Number_MS,d,f)

%   Number_MS ... Number of MS in the simulation
%   Number_BS ... Number of BS in the simulation
%   d ... distance between individual stations in meters
%   f ... frequency in GHz

PL=zeros(1,Number_MS);


for i=1:Number_MS
       PL(i) = 35.2+35*log10(d(i))+26*log10(f/2);
end


end