function RSS = RSS_function(Number_MS,Pt,PL)

%   Number_MS ... Number of MS in the simulation
%   Pt ... Transmission power of MSs
%   PL ... pathlos between individual stations in dB

RSS=zeros(Number_MS);

for i=1:Number_MS
    for j=1:Number_MS
       RSS(i,j) = Pt-PL(i,j);
       if i == j
           RSS(i,j) = 0;
       end
    end
end

end