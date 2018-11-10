function [P] = Probability(Pos_MS,cluster)

% Input: Pos_MS -> Positions of all nodes
%        cluster -> Position of the first cluster (only index)
% Probab_vector -> Probability that this node is the next cluster

pom = zeros(length(Pos_MS),length(cluster));
d = zeros(1,length(Pos_MS));
P = zeros(1,length(Pos_MS));

for i = 1 : length(Pos_MS)
    length(cluster);
    if length(cluster)>1
        for j=1:length(cluster)
            pom(i,j) = sqrt((Pos_MS(1,i)-Pos_MS(1,cluster(j))).^2 + (Pos_MS(2,i)-Pos_MS(2,cluster(j))).^2); % Distance between node(i) and the cluster
            d(i) = max(pom(i,:));
        end
    else
        if cluster==0
            ss=2;
        end
        d(i) = sqrt((Pos_MS(1,i)-Pos_MS(1,cluster)).^2 + (Pos_MS(2,i)-Pos_MS(2,cluster)).^2); % Distance between node(i) and the cluster
    end
    sum_D = sum(d.^2) ;
    
end
for i = 1 : length(Pos_MS)
    P(i) = d(i).^2/sum_D ;
end
end