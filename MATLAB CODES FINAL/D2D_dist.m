function [D2D_dist] = D2D_dist(Pos_MS)

% compute distance between all D2D pairs
% input:
%    Pos_MS ... matrix of position of MS
% output:
%    D2D_dist ... matrix (Number_MS X Number_MS) distance between all MS

D2D_dist = zeros(length(Pos_MS));

for i = 1:length(Pos_MS)
    for j = 1:length(Pos_MS)
        if i ~= j
            D2D_dist (i,j) = sqrt((Pos_MS(1,i)-Pos_MS(1,j))^2 + (Pos_MS(2,i)-Pos_MS(2,j))^2);
        else
            D2D_dist (i,j) = 0;
        end
    end
end

end