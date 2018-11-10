%function to calculate path loss for outdoor to outdoor LOS D2D communication
%constraints :   1-minimum distance between transmitter and receiver is > 3 m
%                2-maximum distance between transmitter and receiver is 5000 m
function [Path_loss]=calculate_O2O_LOS_D2D_path_loss(distance)
Path_loss = zeros(size(distance));
for i = 1:length(distance)
    for j = 1:length(distance)
        d=distance(i,j);
        freq=2;
        hUE = 1.5;
        hBS = 10;
        c = 3*10^8;
                
        PLfreeSpace = 20*log10(d) + 46.4 + 20*log10(freq/5);
        
        %  dxBP - Break Point, Separates Propagation distance
        hxBS=hBS-1; % hxBS= hBS - 1m;   effective eNB antenna height
        
        hxUE=hUE-1; % hxUE= hUE - 1m;   effective UE antenna height
        
        dxBP = 4*hxBS*hxUE*(freq*1000000000/c); % freq needed in [Hz]
        if (d == 0)
            PLd=1;
        elseif ((d > 3) && (d <= dxBP)) % 10m < d < dxBP
            PLd = 28 + 22*log10(d) + 20*log10(freq);        % PATH LOSS
        elseif ((d > dxBP) && (d < 5000))       % dBP < d < 5000m
            
            PLd = 7.8 + 40*log10(d) - 18*log10(hxBS) - 18*log10(hxUE) + 2*log10(freq);        % PATH LOSS
            
        end
        
        PL=PLd;
        
        Path_loss(i,j) = max(PLfreeSpace,PL);
    end
end
end