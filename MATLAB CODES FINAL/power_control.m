function Pt = power_control (N_dBm, PL, SINRth)
% compute Pt for given SINR treshold 
% N_dBm ... noise power in dBm
% PL ... path loss
% SINRth ... SINR treshold
% Pt ... transmiting power

for i = 1:length(PL)
    Pt = SINRth + PL + N_dBm;
end
end