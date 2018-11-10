function Pcon = Pcon_function(Stx,Srx,C,mtx,mrx,cluster)

% Calculate the LTE smartphone power consumption
% Input:
%   Stx ... UL transmit power [dBm]
%   Srx ... DL receive power [dBm]
%   C ... Capacity in Mbps using Shannon
%   mtx ... binary variable indicating active transmission
%   mrx ... binary variable indicating active reception
% Output:
%   Pcon ... Power consumption in RRC_connected mode [W]

Ptx = 29.9e-3; % [W]
Prx = 25.1e-3; % [W]
Pon = 853e-3; % [W]
PtxRF = 0; % [W]
PrxRF = 0; % [W]
Stx_Watts = []; % [W]
Srx_Watts = []; % [W]

for i=1:length(C)
Rtx(i) = C(i); % [Mbps]
Rrx(i) = C(i); % [Mbps]

if Stx(i) <= 0.2 % [dBm]
    Stx_Watts(i) = 1e-3*10^(Stx(i)/10); % [W]
    PtxRF(i) = 0.78*Stx(i) + 23.6; % [dBm]
elseif Stx(i) > 0.2 && Stx(i) <= 11.4 % [dBm]
    Stx_Watts(i) = 1e-3*10^(Stx(i)/10); % [W]
    PtxRF(i) = 17*Stx(i) + 45.4; % [dBm]
elseif Stx(i) > 11.4 % [dBm]
    Stx_Watts(i) = 1e-3*10^(Stx(i)/10); % [W]
    PtxRF(i) = 5.9*(Stx(i))^2 - 118*Stx(i) + 1195; % [dBm]
end
PtxRF(i) = 1e-3*10^(PtxRF(i)/10); % [W]
    
PtxBB = 1e-3*10^(0.62/10); % [W]

if Srx(i) <= -52.5 % [dBm]
    Srx_Watts(i) = 1e-3*10^(Srx(i)/10); % [W]
    PrxRF(i) = -0.04*Srx(i) + 24.8; % [dBm]
elseif Srx(i) > -52.5% [dBm]
    Srx_Watts(i) = 1e-3*10^(Srx(i)/10); % [W]
    PrxRF(i) = -0.11*Srx(i) + 7.86; % [dBm]
end
PrxRF(i) = 1e-3*10^(PrxRF(i)/10); % [W]
    
PrxBB(i) = 0.97*Rrx(i) + 8.16; % [dBm]
PrxBB(i) = 1e-3*10^(PrxBB(i)/10); % [W]

Pcon(i) = Pon + mrx*(Prx + PrxBB(i)*Rrx(i)) + PrxRF(i)*Srx_Watts(i) + mtx*(Ptx + PtxBB*Rtx(i) + PtxRF(i)*Stx_Watts(i));

if i == cluster
    mtx = 1;
    mrx = 1;
Pcon(i) = Pon + mrx*(Prx + PrxBB(i)*Rrx(i)) + PrxRF(i)*Srx_Watts(i) + mtx*(Ptx + PtxBB*Rtx(i) + PtxRF(i)*Stx_Watts(i));
end
end