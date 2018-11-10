function cluster = choose_point_with_probability(Pos_MS,Number_MS,Number_CH)

% choose of cluster head with k-means++
% cluster ... number of MS in order

cluster(1) = round(rand*Number_MS);
if cluster(1)==0
cluster(1)=1;
end
for i=2:Number_CH
    P = Probability(Pos_MS,cluster);
    X = 1:length(Pos_MS(1,:));
    Cumulative_Probabilities=cumsum(P);
    rand_number=rand;
    cluster(i) = X(find(rand_number<Cumulative_Probabilities,1,'first'));
end

