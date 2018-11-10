function pathloss = PL_dream (chain,Pos_MS,area,f)

pathloss = zeros(1,length(chain));

for i = 1:length(chain)
    if i == length(chain)
        dist = sqrt((Pos_MS(1,chain(i))-area)^2 + (Pos_MS(2,chain(i))-area)^2);
    else
        dist = sqrt((Pos_MS(1,chain(i))-Pos_MS(1,chain(i+1)))^2 + (Pos_MS(2,chain(i))-Pos_MS(2,chain(i+1)))^2);
    end
    pathloss(i) = 35.2+35*log10(dist)+26*log10(f/2);
end

end