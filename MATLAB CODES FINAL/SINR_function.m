function [SINR,SINR_dB] = SINR_function(Number_MS,RSS, PL, N_W,Pt,interference)

%   Number_MS ... Number of MS in the simulation
%   RSS ... received signal strength
%   PL ... path loss in dB
%   N_W ... Noise in W
%   Pt ... Transmission power of MS in dBm
%   interference = 1 - on, 0 - off

NI=zeros(Number_MS);

if interference == 1
for i=1:Number_MS
    for j=1:Number_MS
        if i == j
            NI(i,j) = NI(i,j);
        else
            k = 1;
            while k <= Number_MS
                if k == j || k == i
                    k = k + 1;
                else
                    NI(i,j) = NI(i,j) + 10.^-3*10.^( RSS(i,k)/10);   % sum of interference i MS connected to j MS
                    k = k + 1;
                end
            end
        end
        NI(i,j) = NI(i,j) + N_W;     % adding Noise
        NI(i,j)=10*log10(NI(i,j)/0.001); % converting to dBm
    end
    
    
end
end
if interference == 0
    NI = 10*log10(N_W/0.001); % noise in dBm    
end

SINR_dB=Pt-PL-NI;  % SINR calculation in dB

SINR = 10.^(SINR_dB/10);
end