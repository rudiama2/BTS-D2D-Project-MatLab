function Pcon = Pcon_function(Stx,Srx,C,mtx,mrx,cluster,pegasis)

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
Pcon = [];

for i=1:length(C)
    Rtx(i) = C(i); % [Mbps]
    Rrx(i) = C(i); % [Mbps]
    
    if length(Stx) == 1
        if Stx <= 0.2 % [dBm]
            Stx_Watts = 10^(Stx/10); % [mW]
            PtxRF = (0.78*Stx + 23.6)*1e-3; % [W]
        elseif Stx > 0.2 && Stx <= 11.4 % [dBm]
            Stx_Watts = 10^(Stx/10); % [mW]
            PtxRF = (17*Stx + 45.4)*1e-3; % [W]
        elseif Stx > 11.4 % [dBm]
            Stx_Watts = 10^(Stx/10); % [mW]
            PtxRF = (5.9*(Stx)^2 - 118*Stx + 1195)*1e-3; % [W]
        end
    end
    
    if length(Stx) ~= 1
        if Stx(i) <= 0.2 % [dBm]
            Stx_Watts(i) = 10^(Stx(i)/10); % [mW]
            PtxRF(i) = (0.78*Stx(i) + 23.6)*1e-3; % [W]
        elseif Stx(i) > 0.2 && Stx(i) <= 11.4 % [dBm]
            Stx_Watts(i) = 10^(Stx(i)/10); % [mW]
            PtxRF(i) = (17*Stx(i) + 45.4)*1e-3; % [W]
        elseif Stx(i) > 11.4 % [dBm]
            Stx_Watts(i) = 10^(Stx(i)/10); % [mW]
            PtxRF(i) = (5.9*(Stx(i))^2 - 118*Stx(i) + 1195)*1e-3; % [W]
        end
    end
    
    PtxBB = 0.62e-3; % [W]
    
    if Srx(i) <= -52.5 % [dBm]
        Srx_Watts(i) = 10^(Srx(i)/10); % [mW]
        PrxRF(i) = (-0.04*Srx(i) + 24.8)*1e-3; % [W]
    elseif Srx(i) > -52.5% [dBm]
        Srx_Watts(i) = 10^(Srx(i)/10); % [mW]
        PrxRF(i) = (-0.11*Srx(i) + 7.86)*1e-3; % [W]
    end
    % PrxRF(i) = 1e-3*10^(PrxRF(i)/10); % [W]
    
    PrxBB(i) = (0.97*Rrx(i) + 8.16)*1e-3; % [W]
    % PrxBB(i) = 1e-3*10^(PrxBB(i)/10); % [W]
    
    if length(Stx) == 1
        Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF);
        
        if nargin == 6
            if i == cluster
                mtx = 1;
                mrx = 1;
                Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF(i));
            end
        end
    end
    
    if length(Stx) ~= 1
        Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF(i));
        
        if nargin == 6
            if i == cluster
                mtx = 1;
                mrx = 1;
                Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF(i));
            end
        end
    end
    
    
    if length(Stx) == 1
        Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF);
        if nargin == 7
            if i > 1 
                mtx = 1;
                mrx = 1;
                Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF);
            end
        end
    end
    if length(Stx) ~= 1
        Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF(i));
        
        if nargin == 7
            if i > 1
                mtx = 1;
                mrx = 1;
                Pcon(i) = Pon + mrx*(Prx + PrxBB(i) + PrxRF(i)) + mtx*(Ptx + PtxBB + PtxRF(i));
            end
        end
        
    end
end