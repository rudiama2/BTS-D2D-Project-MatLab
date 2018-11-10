function [dist MS_Assoc] = MS_association (Pos_MS, cluster)

% define the cluster head for each MS
% dist ... distance for each MS to cluster head
% MS_Assoc ... cluster head for MS with shortest distance

Pos_C = [Pos_MS(1,cluster) Pos_MS(2,cluster)];

MS_dist = zeros(length(Pos_MS),length(cluster));
MS_Assoc = zeros(1,length(Pos_MS));

for i = 1:length(Pos_MS)
    for j = 1:length(cluster)
        MS_dist(i,j) = sqrt((Pos_MS(1,i)-Pos_C(1,j))^2 + (Pos_MS(2,i)-Pos_C(1,j+length(cluster)))^2);
        k=1;
        while k <= length(cluster) % to eliminate CH from shortest distance
            if i == cluster(k)
                MS_dist(i,j) = 1e5; 
            end
            k = k + 1;
        end
    end
end
MS_dist = MS_dist';
[dist MS_Assoc] = min(MS_dist);

end