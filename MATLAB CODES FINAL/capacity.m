function [C] = capacity(BW,SINR)

%   computation of capacity using shannon
%   C = BW*log2(1+SINR)
%   capacity is in Mbps

C = BW*log2(1+SINR)/1000000;
% for i = 1:length(SINR)
%     C (i,i) = NaN;
% end

end