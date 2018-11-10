function cluster = choose_point_with_probability2(Pos_MS,Number_CH,P)

% choose of cluster head with k-means++
% cluster ... number of MS in order

% cluster(1) = round(rand*Number_MS);
% if cluster(1)==0
% cluster(1)=1;
% end
cluster=zeros(1,Number_CH);
used_now=[];
sss=0;
i=1;
while i<=Number_CH
    %     P = Probability(Pos_MS,cluster);
    X = 1:length(Pos_MS(1,:));
    Cumulative_Probabilities=cumsum(P);
    Cumulative_Probabilities(used_now)=0;
    rand_number=rand;
    cluster(i) = X(find(rand_number<Cumulative_Probabilities,1,'first'));
    if cluster(i)==0
    cluster(i)=1;
    end
            if ismember(cluster(i),used_now )==1     %||      ismember(cluster(k),used_this_round )==1

                cluster(i)=0;                
                sss=2;            
           
            end
            if sss~=2
    used_now=[used_now,cluster(i)];
    i=i+1;
            end
            P=P+(sum(P(used_now))/(length(P)-length(used_now)));
            P(used_now)=0;
end